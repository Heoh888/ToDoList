//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

/// Протокол `TaskListInteractorInput` определяет интерфейс для получения задач из различных источников.
protocol TaskListInteractorInput {
    /// Функция для получения задач из сети
    func fetchTasksFromNetwork()
    /// Функция для получения задач из локального хранения
    func fetchTasksFromLocalStorage()
}

/// Класс `TaskListInteractor` реализует логику для работы с задачами, включая загрузку из сети и локального хранилища.
class TaskListInteractor: TaskListInteractorInput {
    
    var presenter: TaskListPresenterInput?
    private lazy var networkService: NetworkService = NetworkService()
    private lazy var localStorage: StorageManager = StorageManager.shared
    private let operationQueue = OperationQueue()

    /// Функция для получения задач из сети.
    func fetchTasksFromNetwork() {
        DispatchQueue.global(qos: .background).async {
            self.networkService.fetchTasks { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let taskList):
                    self.validateTasksUniqueness(taskList: taskList)  // Валидация уникальности задач
                case .failure(let error):
                    print("Ошибка \(error.localizedDescription)")  // Логирование ошибки
                }
            }
        }
    }
    
    /// Функция для получения задач из локального хранилища.
    func fetchTasksFromLocalStorage() {
        guard let presenter = presenter else { return }
        let localTasks = localStorage.fetchTasks()  // Получение задач из локального хранилища
        let result = convertData(data: localTasks)  // Конвертация данных
        presenter.presentTasks(result)  // Передача задач презентеру
    }
    
    /// Функция для сохранения задач.
    /// - Parameter tasks: Массив задач для сохранения.
    func save(_ tasks: [TaskEntity]) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }
            for task in tasks {
                // Сохранение каждой задачи
                StorageManager.shared.createTask(with: task.id,
                                                  title: task.title,
                                                  descriptionText: task.descriptionText,
                                                  creationDate: task.creationDate,
                                                  isCompleted: task.isCompleted)
            }
            
            OperationQueue.main.addOperation {
                guard let presenter = self.presenter else { return }
                presenter.presentTasks(tasks)  // Передача сохраненных задач презентеру
            }
        }
        operationQueue.addOperation(operation)  // Добавление операции в очередь
    }
    
    /// Проверка уникальности задач.
    /// - Parameter taskList: Список задач для проверки.
    private func validateTasksUniqueness(taskList: TaskListEntity) {
        let localTasks = localStorage.fetchTasks()  // Получение локальных задач
        let tasksFromLocalStorage = convertData(data: localTasks)  // Конвертация локальных задач
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }
            
            // Получение уникальных задач
            let uniqueTasks = Array(Dictionary(uniqueKeysWithValues: (tasksFromLocalStorage + taskList.todos)
                .map { ($0.id, $0) })
                .values)
            
            self.save(uniqueTasks)  // Сохранение уникальных задач
            
            OperationQueue.main.addOperation {
                guard let presenter = self.presenter else { return }
                presenter.presentTasks(uniqueTasks)  // Передача уникальных задач презентеру
            }
        }
        operationQueue.addOperation(operation)  // Добавление операции в очередь
    }
    
    /// Конвертация данных модели задач.
    /// - Parameter data: Массив задач для конвертации.
    /// - Returns: Массив сущностей задач.
    private func convertData(data: [TaskModel]) -> [TaskEntity] {
        data.map { TaskEntity(id: $0.id,
                              title: $0.title,
                              descriptionText: $0.descriptionText,
                              creationDate: $0.creationDate,
                              isCompleted: $0.isCompleted) }  // Конвертация в сущности задач
    }
}

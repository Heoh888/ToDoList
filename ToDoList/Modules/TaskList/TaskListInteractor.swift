//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

protocol TaskListInteractorInput {
    var networkService: NetworkServiceInput? {get set}
    func fetchTasksFromNetwork()
    func fetchTasksFromLocalStorage()
    func deleteTask(with id: Int16)
}

/// Класс `TaskListInteractor` реализует логику для работы с задачами, включая загрузку из сети и локального хранилища.
class TaskListInteractor: TaskListInteractorInput {

    var presenter: TaskListPresenterInput?
    var networkService: NetworkServiceInput?
    var localStorage: StorageManagerInput?
    private let defaults = UserDefaults.standard
    private let operationQueue = OperationQueue()
    
    init(presenter: TaskListPresenterInput? = nil,
         networkService: NetworkServiceInput? = NetworkService(), localStorage: StorageManagerInput? = StorageManager.shared) {
        self.networkService = networkService
        self.presenter = presenter
        self.localStorage = localStorage
    }

    /// Функция для получения задач из сети.
    func fetchTasksFromNetwork() {
        if let firstLaunch = defaults.string(forKey: "firstLaunch") {
            print(firstLaunch)
        } else {
            DispatchQueue.global(qos: .background).async {
                guard let networkService = self.networkService else { return }
                networkService.fetchTasks { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let taskList):
                        defaults.set("The data has already been uploaded", forKey: "firstLaunch")
                        self.validateTasksUniqueness(taskList: taskList)  // Валидация уникальности задач
                    case .failure(let error):
                        print("Ошибка \(error.localizedDescription)")  // Логирование ошибки
                    }
                }
            }
        }
    }
    
    func deleteTask(with id: Int16) {
        guard let localStorage = localStorage else { return }
        localStorage.deleteTask(with: id)
    }
    
    /// Функция для получения задач из локального хранилища.
    func fetchTasksFromLocalStorage() {
        guard let presenter = presenter else { return }
        guard let localStorage = localStorage else { return }
        let localTasks = localStorage.fetchTasks()  // Получение задач из локального хранилища
        let result = convertData(data: localTasks)  // Конвертация данных
        presenter.presentTasks(result)  // Передача задач презентеру
    }
    
    /// Функция для сохранения задач.
    /// - Parameter tasks: Массив задач для сохранения.
    func saveTasks(_ tasks: [TaskEntity]) {
        guard let localStorage = localStorage else { return }
        let localTasks = localStorage.fetchTasks()  // Получение локальных задач
        let tasksFromLocalStorage = self.convertData(data: localTasks)  // Конвертация локальных задач
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }
            for task in tasks {
                // Сохранение каждой задачи
                localStorage.createTask(with: task.id,
                                                 title: task.title,
                                                 descriptionText: task.descriptionText,
                                                 creationDate: task.creationDate,
                                                 isCompleted: task.isCompleted)
            }
            
            guard let presenter = self.presenter else { return }
            let tasks = tasks + tasksFromLocalStorage
            presenter.presentTasks(tasks)  // Передача сохраненных задач презентеру
            
//            OperationQueue.main.addOperation {
//                guard let presenter = self.presenter else { return }
//                let tasks = tasks + tasksFromLocalStorage
//                let sortingTasks = self.sortingTasksByDate(tasks)
//                presenter.presentTasks(sortingTasks)  // Передача сохраненных задач презентеру
//            }
        }
        operationQueue.addOperation(operation)  // Добавление операции в очередь
    }
    
    /// Функция для валидации уникальности задач в списке задач на основе локальных данных.
    /// - Parameter taskList: Объект типа `TaskListEntity`, содержащий список задач для валидации.
    private func validateTasksUniqueness(taskList: TaskListEntity) {
        guard let localStorage = localStorage else { return }
        let localTasks = localStorage.fetchTasks()  // Получение локальных задач
        let tasksFromLocalStorage = convertData(data: localTasks)  // Конвертация локальных задач
        
        // Создаем множество для хранения id задач из локального хранилища
        let existingTaskIds = Set(tasksFromLocalStorage.map { $0.id })
        
        // Фильтруем задачи из taskList.todos, чтобы оставить только уникальные
        let uniqueTasks = taskList.todos.filter { !existingTaskIds.contains($0.id) }
        
        saveTasks(uniqueTasks)
    }
    
    /// Конвертация данных модели задач.
    /// - Parameter data: Массив задач для конвертации.
    /// - Returns: Массив сущностей задач.
    internal func convertData(data: [TaskInput]) -> [TaskEntity] {
        data.map { TaskEntity(id: $0.id,
                              title: $0.title,
                              descriptionText: $0.descriptionText,
                              creationDate: $0.creationDate,
                              isCompleted: $0.isCompleted) }
    }
}

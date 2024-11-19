//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

protocol TaskListInteractorInput {
    func fetchTasksFromNetwork()
    func fetchTasksFromLocalStorage()
    func searchTasks(_ text: String)
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
        let sortingTasks = self.sortingTasksByDate(result)
        presenter.presentTasks(sortingTasks)  // Передача задач презентеру
    }

    /// Функция для сохранения задач.
    /// - Parameter tasks: Массив задач для сохранения.
    func saveTasks(_ tasks: [TaskEntity]) {
        let localTasks = self.localStorage.fetchTasks()  // Получение локальных задач
        let tasksFromLocalStorage = self.convertData(data: localTasks)  // Конвертация локальных задач
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
                let tasks = tasks + tasksFromLocalStorage
                let sortingTasks = self.sortingTasksByDate(tasks)
                presenter.presentTasks(sortingTasks)  // Передача сохраненных задач презентеру
            }
        }
        operationQueue.addOperation(operation)  // Добавление операции в очередь
    }

    func searchTasks(_ text: String) {
        let localTasks = localStorage.fetchTasks()  // Получение локальных задач
        let tasksFromLocalStorage = convertData(data: localTasks)  // Конвертация локальных задач
        let searchLowercased = text.lowercased()
        let result = tasksFromLocalStorage.filter { task in
            // Проверяем, содержится ли `searchText` в `title` или `descriptionText`
            task.title.lowercased().contains(searchLowercased) ||
            (task.descriptionText?.lowercased().contains(searchLowercased) ?? false)
        }
        guard let presenter = self.presenter else { return }
        let tasks = result.isEmpty ? [] : result
        let sortingTasks = sortingTasksByDate(text.isEmpty ? tasksFromLocalStorage : tasks)
        presenter.presentTasks(sortingTasks)
    }

    /// Функция для валидации уникальности задач в списке задач на основе локальных данных.
    /// - Parameter taskList: Объект типа `TaskListEntity`, содержащий список задач для валидации.
    private func validateTasksUniqueness(taskList: TaskListEntity) {
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
    private func convertData(data: [TaskModel]) -> [TaskEntity] {
        data.map { TaskEntity(id: $0.id,
                              title: $0.title,
                              descriptionText: $0.descriptionText,
                              creationDate: $0.creationDate,
                              isCompleted: $0.isCompleted) }
    }

    private func sortingTasksByDate(_ tasks: [TaskEntity]) -> [TaskEntity] {
        tasks.sorted {
            let date1 = $0.creationDate ?? Date.distantPast
            let date2 = $1.creationDate ?? Date.distantPast
            return date1 > date2
        }
    }
}

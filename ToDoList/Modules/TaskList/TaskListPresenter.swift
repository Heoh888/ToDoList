//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

// MARK: - Протокол для ввода презентера списка задач
protocol TaskListPresenterInput {
    /// Представление, с которым работает презентер
    var view: TaskListViewInput? { get set }
    /// Интерфейс взаимодействия с данными
    var interactor: TaskListInteractorInput? { get set }
    /// Отображение задач
    func presentTasks(_ tasks: [TaskEntity])
    /// Получение задач из локального хранилища
    func fetchTasksFromLocalStorage()
    /// Получение задач из сети
    func fetchTasksFromNetwork()
    /// Навигация к деталям задачи
    func navigateToTaskDetail(with task: TaskEntity?)
    /// Поиск задач по тексту
    func searchTasks(_ searchText: String)
    /// Удаление задачи по идентификатору
    func deleteTask(with identifier: Int16)
    /// Сортировка задач по дате
    func sortTasksByDate(_ tasks: [TaskEntity]) -> [TaskEntity]
    /// Метод для начала распознавания речи.
    func startSpeechRecognition(completion: @escaping (String) -> Void)
    /// Метод для остановки распознавания речи.
    func stopSpeechRecognition()
}

// MARK: - Презентер для списка задач
class TaskListPresenter: TaskListPresenterInput {

    // MARK: - Свойства
    /// Связываемое представление
    var view: TaskListViewInput?
    /// Взаимодействие с данными
    var interactor: TaskListInteractorInput?
    /// Маршрутизатор для навигации
    var router: TaskListRouting = TaskListRouter()

    /// Инициализатор для презентера списка задач.
    /// - Parameters:
    /// - view: Представление для отображения задач.
    /// - interactor: Интерфейс для взаимодействия с данными.
    init(view: TaskListViewInput? = nil, interactor: TaskListInteractorInput? = TaskListInteractor()) {
        if let interactorInstance = interactor as? TaskListInteractor {
            interactorInstance.presenter = self // Установка ссылке на презентер
        }
        self.view = view
        self.interactor = interactor
    }

    // MARK: - Методы презентера
    
    /// Метод для начала распознавания речи.
    /// - Parameter completion: Замыкание, которое вызывается с распознанным текстом.
    func startSpeechRecognition(completion: @escaping (String) -> Void) {
        guard let interactor = interactor else { return }
        interactor.startSpeechRecognition { completion($0) }
    }
    
    /// Метод для остановки распознавания речи.
    func stopSpeechRecognition() {
        guard let interactor = interactor else { return }
        interactor.stopSpeechRecognition()
    }
    
    /// Запрашивает задачи из локального хранилища.
    func fetchTasksFromLocalStorage() {
        guard let interactor = interactor else { return }
        interactor.fetchTasksFromLocalStorage()
    }
    
    /// Удаляет задачу по указанному идентификатору.
    /// - Parameters:
    /// - identifier: Идентификатор задачи, которую нужно удалить.
    func deleteTask(with identifier: Int16) {
        guard let interactor = interactor else { return }
        interactor.deleteTask(with: identifier)
    }

    /// Запрашивает задачи из сети.
    func fetchTasksFromNetwork() {
        guard let interactor = interactor else { return }
        interactor.fetchTasksFromNetwork()
    }

    /// Отображает задачи в представлении.
    /// - Parameters:
    /// - tasks: Массив объектов задач для отображения.
    func presentTasks(_ tasks: [TaskEntity]) {
        let sortedTasks = sortTasksByDate(tasks) // Сортировка задач по дате
        view?.showTasks(sortedTasks) // Отображение отсортированных задач
    }

    /// Ищет задачи по указанному тексту.
    /// - Parameters:
    /// - searchText: Текст для поиска задач.
    func searchTasks(_ searchText: String) {
        guard let view = view else { return }
        let searchLowercased = searchText.lowercased()
        guard let interactor = interactor else { return }
        interactor.fetchTasksFromLocalStorage()
        // Фильтр задач, проверяя название и описание
        let filteredTasks = view.tasks.filter { task in
            task.title.lowercased().contains(searchLowercased) ||
            (task.descriptionText?.lowercased().contains(searchLowercased) ?? false)
        }

        // Результаты поиска и сортировка
        let tasksToDisplay = filteredTasks.isEmpty ? [] : filteredTasks
        let sortedTasks = sortTasksByDate(searchText.isEmpty ? view.tasks : tasksToDisplay)
        presentTasks(sortedTasks) // Отображение задач
    }

    /// Навигирует к деталям конкретной задачи.
    /// - Parameters:
    /// - task: Задача, детали которой нужно показать.
    func navigateToTaskDetail(with task: TaskEntity?) {
        guard let currentView = view else { return }
        router.navigateToTaskDetail(from: currentView, with: task)
    }
    
    /// Сортирует задачи по дате создания.
    /// - Parameters:
    /// - tasks: Массив задач для сортировки.
    /// - Returns: Отсортированный массив задач.
    internal func sortTasksByDate(_ tasks: [TaskEntity]) -> [TaskEntity] {
        tasks.sorted {
            let date1 = $0.creationDate ?? Date.distantPast // Дата создания первой задачи
            let date2 = $1.creationDate ?? Date.distantPast // Дата создания второй задачи
            return date1 > date2 // Сравнение дат
        }
    }
}

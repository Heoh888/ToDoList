//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

// MARK: - Протокол для ввода презентера списка задач
protocol TaskListPresenterInput {
    var view: TaskListViewInput? { get set } // Представление, с которым работает презентер
    var interactor: TaskListInteractorInput? { get set } // Интерфейс взаимодействия с данными
    func presentTasks(_ tasks: [TaskEntity]) // Отображение задач
    func fetchTasksFromLocalStorage() // Получение задач из локального хранилища
    func fetchTasksFromNetwork() // Получение задач из сети
    func navigateToTaskDetail(with task: TaskEntity?) // Навигация к деталям задачи
    func searchTasks(_ searchText: String) // Поиск задач по тексту
    func deleteTask(with identifier: Int16) // Удаление задачи по идентификатору
    func sortTasksByDate(_ tasks: [TaskEntity]) -> [TaskEntity] // Сортировка задач по дате
}

// MARK: - Презентер для списка задач
class TaskListPresenter: TaskListPresenterInput {

    // MARK: - Свойства

    var view: TaskListViewInput? // Связываемое представление
    var interactor: TaskListInteractorInput? // Взаимодействие с данными
    var router: TaskListRouting = TaskListRouter() // Маршрутизатор для навигации

    /// Инициализатор для презентера списка задач.
    /// - Parameters:
    /// - view: Представление для отображения задач.
    /// - interactor: Интерфейс для взаимодействия с данными.
    init(view: TaskListViewInput? = nil, interactor: TaskListInteractorInput? = TaskListInteractor()) {
        self.view = view
        self.interactor = interactor
    }

    // MARK: - Методы презентера
    
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

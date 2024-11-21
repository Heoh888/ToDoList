//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//
import Foundation

/// Протокол `TaskListPresenterInput` описывает входные методы, которые должен реализовать презентер.
protocol TaskListPresenterInput {
    var view: TaskListViewInput? { get set }
    var interactor: TaskListInteractorInput? { get set }
    func presentTasks(_ tasks: [TaskEntity])
    func fetchTasksFromLocalStorage()
    func fetchTasksFromNetwork()
    func navigateToTaskDetail(with task: TaskEntity?)
    func searchTasks(_ text: String)
    func deleteTask(with id: Int16)
    func sortingTasksByDate(_ tasks: [TaskEntity]) -> [TaskEntity]
}

/// Класс `TaskListPresenter` реализует протокол `TaskListPresenterInput`
/// и отвечает за взаимодействие между представлением и бизнес-логикой.
///
/// - Properties:
///    - view: Представление, которое будет использоваться для отображения задач.
///    - interactor: Экземпляр интеректора для выполнения операций с данными.
///    - router: Маршрутизатор для навигации между экранами.
class TaskListPresenter: TaskListPresenterInput {

    // MARK: - Properties

    var view: TaskListViewInput? // Слабая ссылка на представление для предотвращения циклов
    var interactor: TaskListInteractorInput? // Экземпляр интеректора
    var router: TaskListRouting = TaskListRouter() // Экземпляр маршрутизатора

    // Инициализатор, в котором происходит связывание интеректора с презентером
    init(view: TaskListViewInput? = nil, interactor: TaskListInteractorInput? = TaskListInteractor()) {
//        if let interactorInstance = interactor as? TaskListInteractor {
//            interactorInstance.presenter = self // Установка ссылке на презентер
//        }
        self.view = view
    }
    
    /// Функция для получения задач из локального хранилища.
    func fetchTasksFromLocalStorage() {
        guard let interactor = interactor else { return }
        interactor.fetchTasksFromLocalStorage()
    }
    
    func deleteTask(with id: Int16) {
        guard let interactor = interactor else { return }
        interactor.deleteTask(with: id)
    }

    /// Функция для получения задач из сети.
    func fetchTasksFromNetwork() {
        guard let interactor = interactor else { return }
        interactor.fetchTasksFromNetwork()
    }

    /// Функция отображает список задач во представлении.
    /// - Parameter tasks: Массив объектов `TaskEntity`, которые нужно отобразить.
    func presentTasks(_ tasks: [TaskEntity]) {
        let sortingTasks = sortingTasksByDate(tasks)
        view?.showTasks(sortingTasks) // Передача задач для отображения в представлении
    }

    func searchTasks(_ text: String) {
        guard let view = view else { return }
        let searchLowercased = text.lowercased()
        let result = view.tasks.filter { task in
            task.title.lowercased().contains(searchLowercased) ||
            (task.descriptionText?.lowercased().contains(searchLowercased) ?? false)
        }
        let tasks = result.isEmpty ? [] : result
        let sortingTasks = sortingTasksByDate(text.isEmpty ? view.tasks : tasks)
        presentTasks(sortingTasks)
    }

    /// Функция для навигации к деталям задачи.
    /// - Parameter task: Объект `TaskEntity?`, который содержит информацию о задаче.
    func navigateToTaskDetail(with task: TaskEntity?) {
        guard let currentView = view else { return } // Проверка наличия представления
        router.navigateToTaskDetail(from: currentView, with: task) // Навигация к деталям задачи
    }
    
    internal func sortingTasksByDate(_ tasks: [TaskEntity]) -> [TaskEntity] {
        tasks.sorted {
            let date1 = $0.creationDate ?? Date.distantPast
            let date2 = $1.creationDate ?? Date.distantPast
            return date1 > date2
        }
    }
}

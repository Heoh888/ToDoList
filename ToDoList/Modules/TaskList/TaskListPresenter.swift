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
    func presentTasks(_ tasks: [TaskEntity])
    func fetchTasksFromLocalStorage()
    func fetchTasksFromNetwork()
    func navigateToTaskDetail(with task: TaskEntity?)
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
    
    weak var view: TaskListViewInput? // Слабая ссылка на представление для предотвращения циклов
    var interactor: TaskListInteractorInput = TaskListInteractor() // Экземпляр интеректора
    var router: TaskListRouting = TaskListRouter() // Экземпляр маршрутизатора
    
    // Инициализатор, в котором происходит связывание интеректора с презентером
    init() {
        if let interactorInstance = interactor as? TaskListInteractor {
            interactorInstance.presenter = self // Установка ссылке на презентер
        }
    }
    
    /// Функция для получения задач из локального хранилища.
    func fetchTasksFromLocalStorage() {
        interactor.fetchTasksFromLocalStorage() // Передача запроса в интеректор
    }
    
    /// Функция для получения задач из сети.
    func fetchTasksFromNetwork() {
        interactor.fetchTasksFromNetwork() // Передача запроса в интеректор
    }
    
    /// Функция отображает список задач во представлении.
    /// - Parameter tasks: Массив объектов `TaskEntity`, которые нужно отобразить.
    func presentTasks(_ tasks: [TaskEntity]) {
        view?.showTasks(tasks) // Передача задач для отображения в представлении
    }
    
    /// Функция для навигации к деталям задачи.
    /// - Parameter task: Объект `TaskEntity?`, который содержит информацию о задаче.
    func navigateToTaskDetail(with task: TaskEntity?) {
        guard let currentView = view else { return } // Проверка наличия представления
        router.navigateToTaskDetail(from: currentView, with: task) // Навигация к деталям задачи
    }
}

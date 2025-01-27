//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation
import Observation

/// Протокол `TaskDetailPresenterInput` определяет интерфейс для презентера деталей задачи.
protocol TaskDetailPresenterInput {
    /// Метод для представления деталей задачи на экране.
    /// - Parameter task: Объект типа `TaskEntity`, представляющий задачу.
    func presentTaskDetails(task: TaskEntity)
    
    /// Метод для создания новой задачи.
    /// - Parameter task: Объект типа `TaskEntity`, представляющий задачу для создания.
    func createTask(_ task: TaskEntity)
    
    /// Метод для обновления существующей задачи.
    /// - Parameter task: Объект типа `TaskEntity`, представляющий задачу для обновления.
    func updateTask(_ task: TaskEntity)
}

/// Класс `TaskDetailPresenter` реализует `TaskDetailPresenterInput`
/// и отвечает за представление деталей задачи.
class TaskDetailPresenter: TaskDetailPresenterInput {

    // MARK: - Свойства
    
    weak var view: TaskDetailViewInput?
    var interactor: TaskDetailInteractor = TaskDetailInteractor()

    // MARK: - Методы

    /// Метод для представления деталей задачи на экране.
    /// - Parameter task: Объект типа `TaskEntity`, представляющий задачу.
    func presentTaskDetails(task: TaskEntity) {
        guard let view = view else { return }
        view.showTaskDetails() // Отображение деталей задачи на представлении
    }

    /// Метод для создания новой задачи.
    /// - Parameter task: Объект типа `TaskEntity`, представляющий задачу для создания.
    func createTask(_ task: TaskEntity) {
        // Вызов метода создания задачи в интеректоре
        self.interactor.createTask(with: task.id,
                                   title: task.title,
                                   descriptionText: task.descriptionText,
                                   creationDate: task.creationDate,
                                   isCompleted: task.isCompleted)
    }

    /// Метод для обновления существующей задачи.
    /// - Parameter task: Объект типа `TaskEntity`, представляющий задачу для обновления.
    func updateTask(_ task: TaskEntity) {
        // Вызов метода обновления задачи в интеректоре
        self.interactor.updateTask(with: task.id,
                                   title: task.title,
                                   descriptionText: task.descriptionText,
                                   creationDate: task.creationDate,
                                   isCompleted: task.isCompleted)
    }
}

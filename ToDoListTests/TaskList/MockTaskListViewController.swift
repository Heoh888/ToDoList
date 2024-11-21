//
//  MockTaskListViewController.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 21.11.2024.
//

import Foundation

/// Класс `MockTaskListViewController` реализует протокол `TaskListViewInput`
/// для имитации поведения контроллера списка задач в тестах.
class MockTaskListViewController: TaskListViewInput {
    
    /// Презентер, отвечающий за логику представления задач
    var presenter: TaskListPresenterInput!
    
    /// Массив задач, отображаемых в контроллере
    var tasks: [TaskEntity] = []
    
    /// Метод, который показывает задачи в контроллере
    /// - Parameters:
    ///   - tasks: Массив объектов `TaskEntity`, который нужно отобразить
    func showTasks(_ tasks: [TaskEntity]) {
        self.tasks = tasks
    }
}

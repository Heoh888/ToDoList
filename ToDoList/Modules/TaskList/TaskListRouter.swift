//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation
import UIKit

// Протокол для маршрутизации списка задач
protocol TaskListRouting {
    /// Функция для перехода к деталям задачи
    /// - Parameters:
    ///   - view: Входное представление списка задач
    ///   - task: Опциональная сущность задачи, для которой нужно показать детали
    func navigateToTaskDetail(from view: TaskListViewInput, with task: TaskEntity?)
}

// Класс, реализующий маршрутизацию задач
final class TaskListRouter: TaskListRouting {
  
    /// Функция для навигации к контроллеру деталей задачи
    /// - Parameters:
    ///   - view: Входное представление списка задач, откуда будет происходить переход
    ///   - task: Опциональная сущность задачи, для которой нужно показать детали
    func navigateToTaskDetail(from view: TaskListViewInput, with task: TaskEntity?) {
        // Инициализация контроллера деталей задачи
        let taskDetailViewController = TaskDetailViewController()
        // Инициализация презентера для контроллера деталей
        let taskDetailPresenter = TaskDetailPresenter()
        
        // Установка презентера в контроллер деталей задачи
        taskDetailViewController.presenter = taskDetailPresenter
        // Передача выбранной задачи в контроллер деталей
        taskDetailViewController.task = task
        
        // Проверка типа входного представления и переход к контроллеру деталей
        if let sourceViewController = view as? UIViewController {
            sourceViewController.navigationController?.pushViewController(taskDetailViewController, animated: true)
        }
    }
}

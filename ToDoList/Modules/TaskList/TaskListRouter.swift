//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation
import UIKit

protocol TaskListRouting {
    func navigateToTaskDetail(from view: TaskListViewInput, with task: TaskEntity?)
}

final class TaskListRouter: TaskListRouting {
    
    func navigateToTaskDetail(from view: TaskListViewInput, with task: TaskEntity?) {
        let taskDetailViewController = TaskDetailViewController()
        let taskDetailPresenter = TaskDetailPresenter()
        taskDetailViewController.presenter = taskDetailPresenter
        taskDetailViewController.task = task
        
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(taskDetailViewController, animated: true)
        }
    }
}

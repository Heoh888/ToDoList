//
//  MockTaskListViewController.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 21.11.2024.
//

import Foundation

class MockTaskListViewController: TaskListViewInput {
    var presenter: TaskListPresenterInput!
    var tasks: [TaskEntity] = []
    
    func showTasks(_ tasks: [TaskEntity]) {
        self.tasks = tasks
    }
}

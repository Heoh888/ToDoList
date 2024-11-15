//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

protocol TaskListInteractorInput {
    func fetchTasks()
}

class TaskListInteractor: TaskListInteractorInput {
    
    var presenter: TaskListPresenterInput?
    var taskService: NetworkService = NetworkService()

    func fetchTasks() {
        DispatchQueue.global(qos: .background).async {
            self.taskService.fetchTasks { result in
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        self.presenter?.presentTasks(success.todos)
                    }
                case .failure(let failure):
                    print("Error \(failure.localizedDescription)")
                }
            }
        }
    }
}

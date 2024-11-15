//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

protocol TaskDetailPresenterInput {
    func presentTaskDetails(task: TaskEntity)
}

class TaskDetailPresenter: TaskDetailPresenterInput {
    
    weak var view: TaskDetailViewInput?
    
    func presentTaskDetails(task: TaskEntity) {
        view?.showTaskDetails()
    }
}

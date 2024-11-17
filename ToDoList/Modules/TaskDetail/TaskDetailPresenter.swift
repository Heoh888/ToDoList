//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

protocol TaskDetailPresenterInput {
    func presentTaskDetails(task: TaskEntity)
    func createTask(_ newTask: TaskEntity)
}

class TaskDetailPresenter: TaskDetailPresenterInput {
    
    weak var view: TaskDetailViewInput?
    var interactor: TaskDetailInteractor = TaskDetailInteractor()
    
    func presentTaskDetails(task: TaskEntity) {
        view?.showTaskDetails()
    }
    
    func createTask(_ newTask: TaskEntity) {
        self.interactor.createTask(with: newTask.id,
                                   title: newTask.title,
                                   descriptionText: newTask.descriptionText,
                                   creationDate: newTask.creationDate,
                                   isCompleted: newTask.isCompleted)
    }
}

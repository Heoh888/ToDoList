//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

protocol TaskDetailPresenterInput {
    func presentTaskDetails(task: TaskEntity)
    func createTask(_ task: TaskEntity)
    func updateTask(_ task: TaskEntity)
}

class TaskDetailPresenter: TaskDetailPresenterInput {

    weak var view: TaskDetailViewInput?
    var interactor: TaskDetailInteractor = TaskDetailInteractor()

    func presentTaskDetails(task: TaskEntity) {
        view?.showTaskDetails()
    }

    func createTask(_ task: TaskEntity) {
        self.interactor.createTask(with: task.id,
                                   title: task.title,
                                   descriptionText: task.descriptionText,
                                   creationDate: task.creationDate,
                                   isCompleted: task.isCompleted)
    }

    func updateTask(_ task: TaskEntity) {
        self.interactor.updateTask(with: task.id,
                                title: task.title,
                                descriptionText: task.descriptionText,
                                creationDate: task.creationDate,
                                isCompleted: task.isCompleted)
    }
}

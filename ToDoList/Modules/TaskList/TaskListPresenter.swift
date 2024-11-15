//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

protocol TaskListPresenterInput {
    var view: TaskListViewInput? { get set }
    func presentTasks(_ tasks: [TaskEntity])
    func loadTasks()
    func navigateToTaskDetail(with task: TaskEntity?)
}

class TaskListPresenter: TaskListPresenterInput {
    
    weak var view: TaskListViewInput?
    var interactor: TaskListInteractorInput = TaskListInteractor()
    var router: TaskListRouting = TaskListRouter()
    
    init() {
        if let interactor = interactor as? TaskListInteractor {
            interactor.presenter = self
        }
    }
    
    func loadTasks() {
        interactor.fetchTasks()
    }
    
    func presentTasks(_ tasks: [TaskEntity]) {
        view?.showTasks(tasks)
    }
    
    func navigateToTaskDetail(with task: TaskEntity?) {
        guard let view = view else { return }
        router.navigateToTaskDetail(from: view, with: task)
    }
}

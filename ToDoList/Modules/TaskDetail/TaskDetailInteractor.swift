//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

class TaskDetailInteractor {
    var presenter: TaskDetailPresenterInput?
    var storage: StorageManager = StorageManager.shared

    func createTask(with id: Int16,
                    title: String,
                    descriptionText: String?,
                    creationDate: Date?,
                    isCompleted: Bool) {
        self.storage.createTask(with: id, title: title,
                           descriptionText: descriptionText,
                           creationDate: creationDate,
                           isCompleted: isCompleted)
    }

    func updateTask(with id: Int16,
                    title: String,
                    descriptionText: String?,
                    creationDate: Date?,
                    isCompleted: Bool) {
        self.storage.updateTask(with: id, title: title,
                           descriptionText: descriptionText,
                           creationDate: creationDate,
                           isCompleted: isCompleted)
    }
}

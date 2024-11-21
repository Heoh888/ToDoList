//
//  TaskDetailInteractor.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

/// Класс `TaskDetailInteractor` отвечает за взаимодействие между презентером и хранилищем данных.
/// Он позволяет создавать и обновлять задачи.
class TaskDetailInteractor {
    var presenter: TaskDetailPresenterInput? // Презентер, отвечающий за отображение данных
    var storage: StorageManager = StorageManager.shared // Менеджер хранения данных, использует синглтон

    /// Функция `createTask` создает новую задачу с заданными параметрами.
    /// - Parameters:
    ///   - taskId: Уникальный идентификатор задачи.
    ///   - taskTitle: Заголовок задачи.
    ///   - taskDescriptionText: Описание задачи (может быть nil).
    ///   - taskCreationDate: Дата создания задачи (может быть nil).
    ///   - taskIsCompleted: Статус выполнения задачи: выполнена или нет.
    func createTask(with taskId: Int16,
                    title taskTitle: String,
                    descriptionText taskDescriptionText: String?,
                    creationDate taskCreationDate: Date?,
                    isCompleted taskIsCompleted: Bool) {
        self.storage.createTask(with: taskId, title: taskTitle,
                                descriptionText: taskDescriptionText,
                                creationDate: taskCreationDate,
                                isCompleted: taskIsCompleted)
    }

    /// Функция `updateTask` обновляет существующую задачу с заданными параметрами.
    /// - Parameters:
    ///   - taskId: Уникальный идентификатор задачи, которую нужно обновить.
    ///   - taskTitle: Заголовок задачи.
    ///   - taskDescriptionText: Описание задачи (может быть nil).
    ///   - taskCreationDate: Дата создания задачи (может быть nil).
    ///   - taskIsCompleted: Новый статус выполнения задачи: выполнена или нет.
    func updateTask(with taskId: Int16,
                    title taskTitle: String,
                    descriptionText taskDescriptionText: String?,
                    creationDate taskCreationDate: Date?,
                    isCompleted taskIsCompleted: Bool) {
        self.storage.updateTask(with: taskId, title: taskTitle,
                                descriptionText: taskDescriptionText,
                                creationDate: taskCreationDate,
                                isCompleted: taskIsCompleted)
    }
}

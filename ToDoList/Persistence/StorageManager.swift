//
//  StorageManager.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import CoreData
import UIKit

/// Протокол `StorageManagerInput` определяет интерфейс для управления задачами в хранилище.
/// Содержит методы для создания, обновления, удаления и получения задач.
protocol StorageManagerInput {
    var tasks: [TaskInput] { get set }
    func fetchTasks() -> [TaskInput]
    func updateTask(with id: Int16,
                    title: String,
                    descriptionText: String?,
                    creationDate: Date?,
                    isCompleted: Bool)
    func createTask(with id: Int16,
                    title: String,
                    descriptionText: String?,
                    creationDate: Date?,
                    isCompleted: Bool)
    func deleteTask(with id: Int16)
}

/// Класс `StorageManager` отвечает за управление задачами, используя Core Data.
/// Включает методы для создания, получения, обновления и удаления задач.
public final class StorageManager: NSObject, StorageManagerInput {

    // MARK: - Singleton Instance
    public static let shared = StorageManager()
    
    // MARK: - Properties
    var tasks: [TaskInput] = []

    private override init() {}

    // MARK: - Core Data Stack
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Ожидается экземпляр AppDelegate")
        }
        return appDelegate
    }

    private var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }

    /// Метод для создания задачи в Core Data.
    /// - Parameters:
    ///   - id: Уникальный идентификатор задачи.
    ///   - title: Заголовок задачи.
    ///   - descriptionText: Описание задачи (может быть nil).
    ///   - creationDate: Дата создания задачи (может быть nil).
    ///   - isCompleted: Статус завершения задачи.
    public func createTask(with id: Int16,
                           title: String,
                           descriptionText: String?,
                           creationDate: Date?,
                           isCompleted: Bool) {
        DispatchQueue.main.async {
            guard let taskEntityDescription = NSEntityDescription
                    .entity(forEntityName: "TaskModel", in: self.context) else { return }
            let task = TaskModel(entity: taskEntityDescription, insertInto: self.context)
            task.id = id
            task.title = title
            task.descriptionText = descriptionText
            task.creationDate = creationDate
            task.isCompleted = isCompleted
            // Сохранение контекста
            self.appDelegate.commitContext()
            // Уведомление о изменении задач
            NotificationCenter.default.post(name: .tasksDidChange, object: nil)
        }
    }

    /// Метод для получения всех задач из Core Data.
    /// - Returns: массив задач, полученных из хранилища.
    func fetchTasks() -> [TaskInput] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        do {
            return (try context.fetch(fetchRequest) as? [TaskModel]) ?? []
        } catch {
            // Если произошла ошибка, возвращаем пустой массив.
            return []
        }
    }

    /// Метод для обновления существующей задачи.
    /// - Parameters:
    ///   - id: Уникальный идентификатор задачи.
    ///   - title: Новый заголовок задачи.
    ///   - descriptionText: Новое описание задачи (может быть nil).
    ///   - creationDate: Новая дата создания задачи (может быть nil).
    ///   - isCompleted: Новый статус завершения задачи.
    public func updateTask(with id: Int16,
                           title: String,
                           descriptionText: String?,
                           creationDate: Date?,
                           isCompleted: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        do {
            guard let tasks = try context.fetch(fetchRequest) as? [TaskModel],
                  let taskToUpdate = tasks.first else { return }
            taskToUpdate.title = title
            taskToUpdate.descriptionText = descriptionText
            taskToUpdate.creationDate = creationDate
            taskToUpdate.isCompleted = isCompleted
            appDelegate.commitContext()
        } catch {
            print(error.localizedDescription)
        }
    }

    /// Метод для удаления задачи по уникальному идентификатору.
    /// - Parameter id: Уникальный идентификатор задачи, которую нужно удалить.
    public func deleteTask(with id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        do {
            guard let tasks = try context.fetch(fetchRequest) as? [TaskModel],
                  let taskToDelete = tasks.first else { return }
            context.delete(taskToDelete)
            appDelegate.commitContext()
            NotificationCenter.default.post(name: .tasksDidChange, object: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}

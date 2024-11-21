//
//  StorageManager.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import CoreData
import UIKit

protocol StorageManagerInput {
    var tasks: [TaskInput] { get set}
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

public final class StorageManager: NSObject, StorageManagerInput {

    public static let shared = StorageManager()
    var tasks: [TaskInput] = []

    private override init() {}

    // MARK: - Core Data Stack
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Expected AppDelegate instance")
        }
        return appDelegate
    }

    private var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }

    // MARK: - CRUD Operations

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
                self.appDelegate.commitContext()
                NotificationCenter.default.post(name: .tasksDidChange, object: nil) // Уведомление о изменении
            }
        }

    func fetchTasks() -> [TaskInput] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskModel")
        do {
            return (try context.fetch(fetchRequest) as? [TaskModel]) ?? []
        } catch {
            return []
        }
    }

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

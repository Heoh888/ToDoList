//
//  MockStorageManager.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 21.11.2024.
//

import Foundation

class MockStorageManager: StorageManagerInput {
    var tasks: [TaskInput] = SupportingData.shared.taskModel
    
    func createTask(with id: Int16, 
                    title: String,
                    descriptionText: String?,
                    creationDate: Date?,
                    isCompleted: Bool) {
    }
    
    func updateTask(with id: Int16, 
                    title: String,
                    descriptionText: String?,
                    creationDate: Date?,
                    isCompleted: Bool) {
    }
    
    func deleteTask(with id: Int16) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks.remove(at: index)
        } else {
            print("Задача с ID \(id) не найдена.")
        }
    }
    
    
    func fetchTasks() -> [TaskInput] {
        SupportingData.shared.taskModel
    }
}

struct MockTask: TaskInput {
    var id: Int16
    var title: String
    var descriptionText: String?
    var creationDate: Date?
    var isCompleted: Bool
}

//
//  TodoListEntity.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

/// Структура `TaskListEntity` представляет собой список задач с их количеством.
struct TaskListEntity: Codable {
    /// Массив задач, представленных объектами `TaskEntity`.
    let todos: [TaskEntity]
    
    /// Общее количество задач в списке.
    let total: Int
}


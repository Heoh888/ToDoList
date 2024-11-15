//
//  TodoListEntity.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

struct TaskListEntity: Codable {
    let todos: [TaskEntity]
    let total: Int
}

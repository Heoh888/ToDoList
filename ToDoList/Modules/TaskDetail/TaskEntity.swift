//
//  TodoEntity.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

struct TaskEntity: Codable {
    let id: Int
    let title: String?
    let descriptionText: String?
    let creationDate: Date?
    let isCompleted: Bool
}

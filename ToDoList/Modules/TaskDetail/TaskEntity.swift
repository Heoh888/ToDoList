//
//  TodoEntity.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

struct TaskEntity: Codable, Equatable, Hashable {
    let id: Int16
    let title: String
    var descriptionText: String?
    var creationDate: Date?
    var isCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case isCompleted = "completed"
        case title = "todo"
        case descriptionText = "description"
        case creationDate = "creation_date"
    }
}

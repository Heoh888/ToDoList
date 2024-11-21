//
//  TodoEntity.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

/// Структура `TaskEntity` представляет собой сущность задачи со свойствами,
struct TaskEntity: Codable, Equatable, Hashable {
    /// Уникальный идентификатор задачи.
    let id: Int16
    
    /// Заголовок задачи.
    let title: String
    
    /// Текст описания задачи. Может быть не задан.
    var descriptionText: String?
    
    /// Дата создания задачи. Может быть не задана.
    var creationDate: Date?
    
    /// Статус выполнения задачи.
    var isCompleted: Bool

    /// Перечисление ключей для кодирования/декодирования задач.
    enum CodingKeys: String, CodingKey {
        case id
        case isCompleted = "completed"
        case title = "todo"
        case descriptionText = "description"
        case creationDate = "creation_date"
    }
}

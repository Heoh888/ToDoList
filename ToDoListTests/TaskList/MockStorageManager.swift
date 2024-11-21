//
//  MockStorageManager.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 21.11.2024.
//

import Foundation

/// `MockStorageManager` - это класс, который реализует протокол `StorageManagerInput`
/// и предоставляет функции для управления задачами (создание, обновление, удаление и получение).
class MockStorageManager: StorageManagerInput {
    /// Массив задач, инициализируемый данными из `SupportingData`.
    var tasks: [TaskInput] = SupportingData.shared.taskModel
    
    /// Функция для создания новой задачи.
    /// - Parameters:
    ///   - id: Уникальный идентификатор задачи.
    ///   - title: Название задачи.
    ///   - descriptionText: Описание задачи (необязательный параметр).
    ///   - creationDate: Дата создания задачи (необязательный параметр).
    ///   - isCompleted: Статус завершенности задачи.
    func createTask(with id: Int16,
                    title: String,
                    descriptionText: String?,
                    creationDate: Date?,
                    isCompleted: Bool) {
        // Здесь требуется реализация функции создания задачи.
        // Добавление новой задачи в массив `tasks`.
    }
    
    /// Функция для обновления существующей задачи.
    /// - Parameters:
    ///   - id: Уникальный идентификатор задачи.
    ///   - title: Название задачи.
    ///   - descriptionText: Описание задачи (необязательный параметр).
    ///   - creationDate: Дата создания задачи (необязательный параметр).
    ///   - isCompleted: Статус завершенности задачи.
    func updateTask(with id: Int16,
                    title: String,
                    descriptionText: String?,
                    creationDate: Date?,
                    isCompleted: Bool) {
        // Здесь требуется реализация функции обновления задачи.
    }
    
    /// Функция для удаления задачи по ID.
    /// - Parameter id: Уникальный идентификатор задачи.
    func deleteTask(with id: Int16) {
        // Получаем индекс задачи с указанным ID.
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            // Удаляем задачу из массива.
            tasks.remove(at: index)
        } else {
            // Выводим сообщение, если задача с данным ID не найдена.
            print("Задача с ID \(id) не найдена.")
        }
    }
    
    /// Функция для получения всех задач.
    /// - Returns: Массив задач типа `TaskInput`.
    func fetchTasks() -> [TaskInput] {
        // Возвращаем массив задач.
        return SupportingData.shared.taskModel
    }
}

/// `MockTask` - структура, представляющая задачу, которая соответствует протоколу `TaskInput`.
struct MockTask: TaskInput {
    var id: Int16
    var title: String
    var descriptionText: String?
    var creationDate: Date?
    var isCompleted: Bool
}

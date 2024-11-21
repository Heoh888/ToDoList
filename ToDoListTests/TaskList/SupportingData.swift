//
//  SupportingData.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 21.11.2024.
//

import Foundation

/// Класс SupportingData представляет собой singleton, который содержит
/// данные о задачах для использования в приложении.
class SupportingData {
    
    /// Статическая переменная для доступа к единственному экземпляру класса SupportingData.
    public static let shared = SupportingData()
    
    /// Делаем инициализатор закрытым, чтобы предотвратить создание экземпляров из вне класса.
    private init() {}
    
    /// Массив сущностей задач, которые содержат идентификатор, название,
    /// дату создания и статус завершенности.
    public let taskEntity: [TaskEntity] = [
        .init(id: 1, title: "Test 1", creationDate: Date(timeIntervalSinceNow: -10000), isCompleted: true),
        .init(id: 2, title: "Test 2", creationDate: Date(timeIntervalSinceNow: -5000), isCompleted: true),
        .init(id: 3, title: "Test 3", creationDate: Date(timeIntervalSinceNow: -6000), isCompleted: true),
        .init(id: 4, title: "Test 4", creationDate: nil, isCompleted: true),
    ]
    
    /// Массив моделей задач, которые повторяют структуру taskEntity,
    /// предназначен для использования в тестировании и моделировании.
    public let taskModel: [MockTask] = [
        .init(id: 1, title: "Test 1", creationDate: Date(timeIntervalSinceNow: -10000), isCompleted: true),
        .init(id: 2, title: "Test 2", creationDate: Date(timeIntervalSinceNow: -5000), isCompleted: true),
        .init(id: 3, title: "Test 3", creationDate: Date(timeIntervalSinceNow: -6000), isCompleted: true),
        .init(id: 4, title: "Test 4", creationDate: nil, isCompleted: true),
    ]
}

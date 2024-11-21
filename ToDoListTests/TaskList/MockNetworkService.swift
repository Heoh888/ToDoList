//
//  MockNetworkService.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 20.11.2024.
//

import Foundation

/// Класс `MockNetworkService` реализует протокол `NetworkServiceInput` и служит для
/// имитации сетевых запросов в тестах.
class MockNetworkService: NetworkServiceInput {
    /// Указывает, следует ли возвращать ошибку в запросах
    var shouldReturnError = false
    
    /// Функция `fetchTasks` извлекает список задач и передает его через completion handler.
    /// - Parameter completion: Завершение с результатом, который содержит
    /// либо список задач, либо ошибку.
    func fetchTasks(completion: @escaping (Result<TaskListEntity, Error>) -> Void) {
        // Если должна произойти ошибка, возвращаем её.
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 1, userInfo: nil)))
        } else {
            // Извлекаем задачи
            let tasks = SupportingData.shared.taskEntity
            // Создаем объект списка задач
            let taskList = TaskListEntity(todos: tasks, total: tasks.count)
            // Вызываем completion handler на главном потоке, чтобы избежать проблем с UI
            DispatchQueue.main.async {
                completion(.success(taskList))
            }
        }
    }
}

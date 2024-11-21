//
//  MockNetworkService.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 20.11.2024.
//

import Foundation

class MockNetworkService: NetworkServiceInput {
    var shouldReturnError = false
    
    func fetchTasks(completion: @escaping (Result<TaskListEntity, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "NetworkError", code: 1, userInfo: nil)))
        } else {
            let tasks = SupportingData.shared.taskEntity
            let taskList = TaskListEntity(todos: tasks, total: tasks.count)
            DispatchQueue.main.async {
                completion(.success(taskList))
            }
        }
    }
}

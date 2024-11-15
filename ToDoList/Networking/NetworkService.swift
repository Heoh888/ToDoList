//
//  NetworkService.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

final class NetworkService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchTasks(completion: @escaping (Result<TaskListEntity, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let todoResponse = try decoder.decode(TaskListEntity.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(todoResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

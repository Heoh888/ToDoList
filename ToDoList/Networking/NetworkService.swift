//
//  NetworkService.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

/// Протокол `NetworkServiceInput` определяет входной интерфейс для сетевых операций.
protocol NetworkServiceInput {
    /// Функция для получения списка задач.
    /// - Parameters:
    ///   - completion: Замыкание, возвращающее результат в виде `TaskListEntity` или ошибки.
    func fetchTasks(completion: @escaping (Result<TaskListEntity, Error>) -> Void)
}

/// Класс `NetworkService` реализует протокол `NetworkServiceInput` для выполнения сетевых запросов.
final class NetworkService: NetworkServiceInput {
    private let urlSession: URLSession  // Переименована переменная session для улучшения читаемости.

    /// Инициализатор класса `NetworkService`.
    /// - Parameter session: Сессия для выполнения сетевых запросов, по умолчанию используется `URLSession.shared`.
    init(session: URLSession = .shared) {
        self.urlSession = session
    }

    /// Функция для получения списка задач из сети.
    /// - Parameter completion: Замыкание, возвращающее результат в виде `TaskListEntity` или ошибки.
    func fetchTasks(completion: @escaping (Result<TaskListEntity, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { // Проверка корректности URL
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Неверный URL"])))
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            if let error = error { // Обработка ошибки
                completion(.failure(error))
                return
            }

            guard let data = data else { // Проверка наличия данных
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Нет данных"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let todoResponse = try decoder.decode(TaskListEntity.self, from: data)
                DispatchQueue.main.async { // Обработка результата на главном потоке
                    completion(.success(todoResponse))
                }
            } catch {
                completion(.failure(error)) // Обработка ошибок декодирования
            }
        }
        dataTask.resume() // Запуск задачи
    }
}

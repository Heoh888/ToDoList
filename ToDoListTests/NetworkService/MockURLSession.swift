//
//  MockURLSession.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

/// `MockURLSession` — это класс, который наследует `URLSession` и используется для имитации сетевых вызовов в тестах.
class MockURLSession: URLSession {
    // Данные для имитации ответа, которые будут возвращены при вызове.
    var mockData: Data?
    // Ошибка для имитации сетевой ошибки, если такая появилась.
    var mockError: Error?

    /// Функция `dataTask` переопределяет стандартный метод `dataTask` класса `URLSession`.
    /// - Parameters:
    ///   - url: URL, который будет использоваться в сетевом вызове.
    ///   - completionHandler: Замыкание, которое будет вызвано после завершения задания с результатом - данными, ответом или ошибкой.
    /// - Returns: Возвращает `MockURLSessionDataTask` для имитации сетевых задач.
    override func dataTask(with url: URL,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        // Проверка на наличие имитируемой ошибки
        if let errorToReturn = mockError {
            // Если ошибка присутствует, вызываем обработчик с nil данными и ошибкой
            completionHandler(nil, nil, errorToReturn)
        } else {
            // Если ошибки нет, вызываем обработчик с имитированными данными и nil ошибкой
            completionHandler(mockData, nil, nil)
        }
        // Возвращаем экземпляр имитированного задания
        return MockURLSessionDataTask()
    }
}

/// `MockURLSessionDataTask` — это класс, который наследует `URLSessionDataTask` и используется для имитации сетевых задач.
class MockURLSessionDataTask: URLSessionDataTask {
    /// Переопределяем метод `resume`, чтобы он ничего не выполнял.
    override func resume() { }
}

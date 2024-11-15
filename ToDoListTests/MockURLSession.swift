//
//  MockURLSession.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation

class MockURLSession: URLSession {
    var mockData: Data?
    var mockError: Error?

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if let mockError = mockError {
            completionHandler(nil, nil, mockError) // Возвращаем ошибку, если она есть
        } else {
            completionHandler(mockData, nil, nil)  // Возвращаем данные
        }
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    override func resume() { } // Не выполняем никаких действий
}

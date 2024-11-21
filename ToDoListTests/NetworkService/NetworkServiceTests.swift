//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 15.11.2024.
//
import XCTest
@testable import ToDoList

/// Класс для тестирования сетевых услуг. Наследуется от `XCTestCase`.
class NetworkServiceTests: XCTestCase {
    // Свойство для сервиса сетевого взаимодействия
    var networkService: NetworkService!
    // Провайдер для имитации URL сессий
    var mockURLSession: MockURLSession!
    
    /// Метод, который запускается перед выполнением каждого теста.
    override func setUp() {
        super.setUp()
        // Инициализация имитированной сессии
        mockURLSession = MockURLSession()
        // Инициализация сервиса с использованием имитированной сессии
        networkService = NetworkService(session: mockURLSession)
    }

    /// Тест, который проверяет, что метод `fetchTasks` возвращает задачи.
    func testFetchTasksReturnsTasks() {
        let jsonString = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "Do something nice for someone you care about",
                    "completed": false,
                    "userId": 152
                }
            ],
            "total": 1,
            "skip": 0,
            "limit": 1
        }
        """
        
        // Преобразование строки JSON в данные
        if let jsonData = jsonString.data(using: .utf8) {
            // Присвоение данных для имитированной сессии
            mockURLSession.mockData = jsonData
            
            // Ожидание завершения асинхронной работы
            let fetchExpectation = XCTestExpectation(description: "Fetch tasks")
            
            // Вызов метода для получения задач
            networkService.fetchTasks { result in
                switch result {
                case .success(let fetchedTasks):
                    // Проверка полученных данных
                    XCTAssertEqual(fetchedTasks.total, 1)
                    XCTAssertEqual(fetchedTasks.todos.count, 1)
                    XCTAssertEqual(fetchedTasks.todos.first?.title, "Do something nice for someone you care about")
                    fetchExpectation.fulfill()
                case .failure(let error):
                    print(error)
                }
            }
            
            // Ожидание завершения асинхронного теста
            wait(for: [fetchExpectation], timeout: 1.0)
        } else {
            print("Ошибка при преобразовании строки в данные.")
        }
    }

    /// Тест, который проверяет, как метод `fetchTasks` обрабатывает ошибки.
    func testFetchTasksHandlesError() {
        // Присвоение имитированной ошибки для сессии
        mockURLSession.mockError = NSError(domain: "", code: 404, userInfo: nil)

        // Ожидание завершения асинхронной работы
        let errorExpectation = XCTestExpectation(description: "Handle error gracefully")

        // Вызов метода для получения задач
        networkService.fetchTasks { result in
            switch result {
            case .success(let fetchedTasks):
                print(fetchedTasks)
            case .failure(let error):
                // Проверка, что описание ошибки не пустое
                XCTAssertTrue(!error.localizedDescription.isEmpty, "Описание ошибки не должно быть пустым")
                errorExpectation.fulfill()
            }
        }
        
        // Ожидание завершения асинхронного теста
        wait(for: [errorExpectation], timeout: 1.0)
    }
}

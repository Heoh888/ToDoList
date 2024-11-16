//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import XCTest
@testable import ToDoList

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }

    func testFetchTasksReturnsTasks() {
        let jsonData = """
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
        """.data(using: .utf8)

        mockSession.mockData = jsonData

        let expectation = XCTestExpectation(description: "Fetch tasks")

        networkService.fetchTasks { result in
            switch result {
            case .success(let success):
                // Здесь выполните проверки на результат
                XCTAssertEqual(success.total, 1)
                XCTAssertEqual(success.todos.count, 1)
                XCTAssertEqual(success.todos.first?.title, "Do something nice for someone you care about")
                expectation.fulfill()
            case .failure(let failure):
                print("")
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchTasksHandlesError() {
        mockSession.mockError = NSError(domain: "", code: 404, userInfo: nil)

        let expectation = XCTestExpectation(description: "Handle error gracefully")

        networkService.fetchTasks { result in
            switch result {
            case .success(let success):
                print("")
            case .failure(let failure):
                XCTAssertTrue(!failure.localizedDescription.isEmpty, "The line should not be empty")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

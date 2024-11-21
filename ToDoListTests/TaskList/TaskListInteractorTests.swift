//
//  File.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 20.11.2024.
//

import XCTest
@testable import ToDoList

class TaskListInteractorTests: XCTestCase {
    
    var mockStorageManager: MockStorageManager!
    var mockNetworkService: MockNetworkService!
    var interactor: TaskListInteractor!
    var presenter: TaskListPresenter!
    var view: MockTaskListViewController!
    let defaults = UserDefaults.standard
    
    override func setUp() {
        defaults.set("The data has already been uploaded", forKey: "firstLaunch")
        mockStorageManager = MockStorageManager()
        mockNetworkService = MockNetworkService()
        view = MockTaskListViewController()
        interactor = TaskListInteractor(networkService: mockNetworkService, localStorage: mockStorageManager)
        presenter = TaskListPresenter(view: view, interactor: interactor)
        super.setUp()
    }
    
    override func tearDown() {
        mockStorageManager = nil
        interactor = nil
        super.tearDown()
    }
    
    func testDeleteTask() {
        interactor.deleteTask(with: 1)
        XCTAssertEqual(interactor.localStorage?.tasks.count, 3)
    }
    
    func testConvertData() {

        let inputData: [TaskInput] = SupportingData.shared.taskModel
        
        let expectedOutput: [TaskEntity] = SupportingData.shared.taskEntity

        let outputData = interactor.convertData(data: inputData)

        XCTAssertEqual(outputData.count, expectedOutput.count, "Output count should match expected count")
        
        for (index, entity) in outputData.enumerated() {
            XCTAssertEqual(entity.id, expectedOutput[index].id, "IDs should match")
            XCTAssertEqual(entity.title, expectedOutput[index].title, "Titles should match")
            XCTAssertEqual(entity.descriptionText, expectedOutput[index].descriptionText, "Description texts should match")
            XCTAssertEqual(entity.isCompleted, expectedOutput[index].isCompleted, "Completion status should match")
        }
    }
}


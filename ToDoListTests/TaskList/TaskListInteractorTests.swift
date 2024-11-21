//
//  File.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 20.11.2024.
//

import XCTest
@testable import ToDoList

/// Класс тестов для `TaskListInteractor`, который обеспечивает проверку взаимодействий с данными задач.
class TaskListInteractorTests: XCTestCase {
    
    var mockTaskStorageManager: MockStorageManager!
    var mockTaskNetworkService: MockNetworkService!
    var interactor: TaskListInteractor!
    var presenter: TaskListPresenter!
    var mockTaskListView: MockTaskListViewController!
    let userDefaults = UserDefaults.standard
    
    override func setUp() {
        super.setUp()
        userDefaults.set("The data has already been uploaded", forKey: "firstLaunch")
        mockTaskStorageManager = MockStorageManager()
        mockTaskNetworkService = MockNetworkService()
        mockTaskListView = MockTaskListViewController()
        interactor = TaskListInteractor(networkService: mockTaskNetworkService, localStorage: mockTaskStorageManager)
        presenter = TaskListPresenter(view: mockTaskListView, interactor: interactor)
    }
    
    override func tearDown() {
        mockTaskStorageManager = nil
        interactor = nil
        super.tearDown()
    }
    
    /// Тестирует функцию удаления задачи.
    func testDeleteTask() {
        interactor.deleteTask(with: 1)
        XCTAssertEqual(interactor.localStorage?.tasks.count, 3, "Количество задач после удаления должно быть равно 3")
    }
    
    /// Тестирует функцию преобразования входных данных в сущности задач.
    func testConvertData() {
        let inputTaskData: [TaskInput] = SupportingData.shared.taskModel
        let expectedTaskEntities: [TaskEntity] = SupportingData.shared.taskEntity

        let outputTaskData = interactor.convertData(data: inputTaskData)

        XCTAssertEqual(outputTaskData.count, expectedTaskEntities.count, "Количество выходных данных должно совпадать с ожидаемым количеством")
        
        for (index, taskEntity) in outputTaskData.enumerated() {
            XCTAssertEqual(taskEntity.id, expectedTaskEntities[index].id, "Идентификаторы должны совпадать")
            XCTAssertEqual(taskEntity.title, expectedTaskEntities[index].title, "Названия должны совпадать")
            XCTAssertEqual(taskEntity.descriptionText, expectedTaskEntities[index].descriptionText, "Тексты описаний должны совпадать")
            XCTAssertEqual(taskEntity.isCompleted, expectedTaskEntities[index].isCompleted, "Статусы завершенности должны совпадать")
        }
    }
}


//
//  TaskListPresenterTest.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 21.11.2024.
//

import XCTest
@testable import ToDoList

class TaskListPresenterTest: XCTestCase {
    
    var view: MockTaskListViewController!
    var presenter: TaskListPresenter!
    
    override func setUp() {
        super.setUp()
        view = MockTaskListViewController()
        presenter = TaskListPresenter(view: view)
    }
    
    override func tearDown() {
        presenter = nil
        super.tearDown()
    }
    
    func testSortingTasksByDate() {
        let task1 = TaskEntity(id: 1, title: "2", creationDate: Date(timeIntervalSinceNow: -10000), isCompleted: true)
        let task2 = TaskEntity(id: 2, title: "2", creationDate: Date(timeIntervalSinceNow: -5000), isCompleted: true)
        let task3 = TaskEntity(id: 3, title: "2", creationDate: Date(timeIntervalSinceNow: -6000), isCompleted: true)
        let task4 = TaskEntity(id: 3, title: "2", creationDate: nil, isCompleted: true)
        
        let tasks = [task4, task1, task2, task3]

        let expectedSortedTasks = [task2, task3, task1, task4]
        
        let sortedTasks = presenter.sortingTasksByDate(tasks)

        XCTAssertEqual(sortedTasks, expectedSortedTasks, "Tasks were not sorted correctly by date.")
    }
    
    func testSearchTasks_WithMatchingTitle_ReturnsCorrectTasks() {

        let tasks = [
            TaskEntity(id: 1, title: "Buy milk", descriptionText: "Get some milk from the store.", isCompleted: true),
            TaskEntity(id: 1, title: "Go to gym", descriptionText: "Evening workout.", isCompleted: true),
            TaskEntity(id: 1, title: "Buy bread", descriptionText: nil, isCompleted: true)
        ]
        presenter.view!.tasks = tasks

        presenter.searchTasks("buy")
        print(view.tasks)

        XCTAssertEqual(presenter.view?.tasks.count, 2)
        XCTAssertEqual(presenter.view?.tasks[0].title, "Buy milk")
        XCTAssertEqual(presenter.view?.tasks[1].title, "Buy bread")
    }
}

//
//  TaskListPresenterTest.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 21.11.2024.
//

import XCTest
@testable import ToDoList

/// Класс тестирования `TaskListPresenter`, который отвечает за логику сортировки и поиска задач.
class TaskListPresenterTest: XCTestCase {
    
    var mockView: MockTaskListViewController! // Представление, использующееся для тестов.
    var taskListPresenter: TaskListPresenter! // Презентер, который будем тестировать.
    
    override func setUp() {
        super.setUp()
        mockView = MockTaskListViewController() // Инициализация Mock представления.
        taskListPresenter = TaskListPresenter(view: mockView) // Инициализация презентера с mockView.
    }
    
    override func tearDown() {
        taskListPresenter = nil // Освобождаем память после теста.
        super.tearDown()
    }
    
    /// Тестирует сортировку задач по дате создания.
    func testSortingTasksByDate() {
        let task1 = TaskEntity(id: 1, title: "Задача 1", creationDate: Date(timeIntervalSinceNow: -10000), isCompleted: true)
        let task2 = TaskEntity(id: 2, title: "Задача 2", creationDate: Date(timeIntervalSinceNow: -5000), isCompleted: true)
        let task3 = TaskEntity(id: 3, title: "Задача 3", creationDate: Date(timeIntervalSinceNow: -6000), isCompleted: true)
        let task4 = TaskEntity(id: 4, title: "Задача 4", creationDate: nil, isCompleted: true) // Обратите внимание на уникальный id.
        
        let tasks = [task4, task1, task2, task3] // Нерассортированный массив задач.

        let expectedSortedTasks = [task2, task3, task1, task4] // Ожидаемый результат сортировки.
        
        let sortedTasks = taskListPresenter.sortTasksByDate(tasks) // Выполняем тестируемую функцию.

        XCTAssertEqual(sortedTasks, expectedSortedTasks, "Tasks were not sorted correctly by date.") // Проверяем корректность сортировки.
    }
    
    /// Тестирует поиск задач по заголовку (title).
    func testSearchTasks_WithMatchingTitle_ReturnsCorrectTasks() {
        let tasks = [
            TaskEntity(id: 1, title: "Купить молоко", descriptionText: "Купить молоко в магазине.", isCompleted: true),
            TaskEntity(id: 2, title: "Сходить в зал", descriptionText: "Вечерняя тренировка.", isCompleted: true),
            TaskEntity(id: 3, title: "Купить хлеб", descriptionText: nil, isCompleted: true)
        ]
        taskListPresenter.view!.tasks = tasks // Устанавливаем тестовые задачи в представление.

        taskListPresenter.searchTasks("купить") // Ищем задачи, содержащие слово "купить".

        XCTAssertEqual(taskListPresenter.view?.tasks.count, 2) // Проверяем количество найденных задач.
        XCTAssertEqual(taskListPresenter.view?.tasks[0].title, "Купить молоко") // Проверка первой найденной задачи.
        XCTAssertEqual(taskListPresenter.view?.tasks[1].title, "Купить хлеб") // Проверка второй найденной задачи.
    }
}

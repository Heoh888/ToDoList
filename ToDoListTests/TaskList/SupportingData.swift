//
//  SupportingData.swift
//  ToDoListTests
//
//  Created by Алексей Ходаков on 21.11.2024.
//

import Foundation

class SupportingData {
    public static let shared = SupportingData()
    private init() {}
    
    public let taskEntity: [TaskEntity] = [
        .init(id: 1, title: "Test 1", creationDate: Date(timeIntervalSinceNow: -10000), isCompleted: true),
        .init(id: 2, title: "Test 2", creationDate: Date(timeIntervalSinceNow: -5000), isCompleted: true),
        .init(id: 3, title: "Test 3", creationDate: Date(timeIntervalSinceNow: -6000), isCompleted: true),
        .init(id: 4, title: "Test 4", creationDate: nil, isCompleted: true),
    ]
    
    public let taskModel: [MockTask] = [
        .init(id: 1, title: "Test 1", creationDate: Date(timeIntervalSinceNow: -10000), isCompleted: true),
        .init(id: 2, title: "Test 2", creationDate: Date(timeIntervalSinceNow: -5000), isCompleted: true),
        .init(id: 3, title: "Test 3", creationDate: Date(timeIntervalSinceNow: -6000), isCompleted: true),
        .init(id: 4, title: "Test 4", creationDate: nil, isCompleted: true),
    ]
    
    
}

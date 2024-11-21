//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//
//

import Foundation
import CoreData

protocol TaskInput {
    var id: Int16 { get set }
    var title: String { get set }
    var descriptionText: String? { get set }
    var creationDate: Date? { get set }
    var isCompleted: Bool { get set }
}

@objc(TaskModel)
public class TaskModel: NSManagedObject {}

extension TaskModel: TaskInput {
    @NSManaged public var id: Int16
    @NSManaged public var title: String
    @NSManaged public var descriptionText: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var isCompleted: Bool
}

extension TaskModel: Identifiable {}

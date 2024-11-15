//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {}

extension Task {
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var isCompleted: Bool
}

extension Task : Identifiable {}

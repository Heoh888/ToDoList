//
//  Date.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 17.11.2024.
//

import Foundation

extension Date {
    func currentDateToString() -> String {
        DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
    }
}

extension UUID {
    func uuidToInt16() -> Int16? {
        let uuidBytes = uuid
        let uint16Value = (UInt16(uuidBytes.0) << 8) | UInt16(uuidBytes.1)
        return Int16(truncatingIfNeeded: uint16Value)
    }

}

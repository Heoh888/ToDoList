//
//  Date.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 17.11.2024.
//

import Foundation

/// Расширение класса `Date`, добавляющее возможность форматирования даты в строку.
extension Date {
    /// Метод для форматирования даты в строковом представлении.
    /// - Returns: Возвращает строку в формате "dd/MM/yyyy"
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: self)
    }
}

/// Расширение класса `UUID`, позволяющее конвертировать UUID в Int16.
extension UUID {
    /// Метод для преобразования UUID в значение типа Int16.
    /// - Returns: Возвращает значение Int16, представляющее первые 16 бит UUID,
    ///  или `nil`, если не удается преобразовать.
    func uuidToInt16() -> Int16? {
        let uuidBytes = uuid // Получаем байты UUID
        let uint16Value = (UInt16(uuidBytes.0) << 8) | UInt16(uuidBytes.1) // Объединяем два байта в UInt16
        return Int16(truncatingIfNeeded: uint16Value)
    }
}

/// Расширение для класса `Notification.Name`, добавляющее константу для уведомлений о изменении задач.
extension Notification.Name {
    /// Константа уведомления, которая сигнализирует о том, что изменились задачи.
    static let tasksDidChange = Notification.Name("tasksDidChange")
}

/// Расширение для типа `String`, которое добавляет функциональность для преобразования строк в объекты Date.
extension String {
    
    /// Метод для преобразования строки в объект Date.
    /// - Parameters:
    ///   - format: Формат даты. По умолчанию используется "dd/MM/yy".
    /// - Returns: Объект Date, если преобразование прошло успешно, иначе nil.
    func toDate(format: String = "dd/MM/yy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

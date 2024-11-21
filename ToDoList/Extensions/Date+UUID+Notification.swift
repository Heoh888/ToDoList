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
        dateFormatter.dateFormat = "dd/MM/yyyy" // Задаем формат даты
        return dateFormatter.string(from: self) // Возвращаем форматированную строку
    }
}

/// Расширение класса `UUID`, позволяющее конвертировать UUID в Int16.
extension UUID {
    /// Метод для преобразования UUID в значение типа Int16.
    /// - Returns: Возвращает значение Int16, представляющее первые 16 бит UUID, или `nil`, если не удается преобразовать.
    func uuidToInt16() -> Int16? {
        let uuidBytes = uuid // Получаем байты UUID
        let uint16Value = (UInt16(uuidBytes.0) << 8) | UInt16(uuidBytes.1) // Объединяем два байта в UInt16
        return Int16(truncatingIfNeeded: uint16Value) // Преобразуем в Int16 с обработкой переполнения
    }
}

/// Расширение для класса `Notification.Name`, добавляющее константу для уведомлений о изменении задач.
extension Notification.Name {
    /// Константа уведомления, которая сигнализирует о том, что изменились задачи.
    static let tasksDidChange = Notification.Name("tasksDidChange") // Наблюдаемая константа для изменения задач
}

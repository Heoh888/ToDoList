//
//  DatePickerViewModel.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 25.01.2025.
//

import Foundation
import Observation

/// `DatePickerViewModel` представляет собой модель представления для выбора даты.
@Observable
class DatePickerViewModel {
    
    /// День, выбранный пользователем.
    var selectedDay = Calendar.current.component(.day, from: Date())
    /// Месяц, выбранный пользователем.
    var selectedMonth = Calendar.current.component(.month, from: Date())
    /// Год, выбранный пользователем.
    var selectedYear = Calendar.current.component(.year, from: Date())
    
    /// Функция для установки даты из строки.
    /// - Parameters:
    ///   - dateString: Строка, представляющая дату (например, "2023-10-12").
    func setDate(from dateString: String) {
        if let date = dateString.toDate() {
            let calendar = Calendar.current
            selectedDay = calendar.component(.day, from: date)
            selectedMonth = calendar.component(.month, from: date)
            selectedYear = calendar.component(.year, from: date)
        } else {
            print("Ошибка: Невозможно преобразовать строку в дату")
        }
    }
    
    /// Функция для получения даты в виде строки.
    /// - Returns: Строка, представляющая дату в формате.
    func getDate() -> String {
        let components = DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)
        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return date.formatDate()
        }
        return "Ошибка"
    }
    
    /// Функция для вычисления количества дней в указанном месяце и году.
    /// - Parameters:
    ///   - month: Месяц, для которого нужно вычислить количество дней.
    ///   - year: Год, для которого нужно вычислить количество дней.
    /// - Returns: Количество дней в указанном месяце.
    func daysInMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents) {
            return calendar.range(of: .day, in: .month, for: date)!.count
        }
        return 0 //В случае ошибки возвращаем 0
    }
}

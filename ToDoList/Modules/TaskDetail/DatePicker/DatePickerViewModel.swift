//
//  DatePickerViewModel.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 25.01.2025.
//

import Foundation
import Observation

@Observable
class DatePickerViewModel {
    
    var selectedDay = Calendar.current.component(.day, from: Date())
    var selectedMonth = Calendar.current.component(.month, from: Date())
    var selectedYear = Calendar.current.component(.year, from: Date())
    
    func setDate(from string: String) {
        if let date = string.toDate() {
            let calendar = Calendar.current
            selectedDay = calendar.component(.day, from: date)
            selectedMonth = calendar.component(.month, from: date)
            selectedYear = calendar.component(.year, from: date)
        } else {
            print("Ошибка: Невозможно преобразовать строку в дату")
        }
    }
    
    func getDate() -> String {
        let components = DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)
        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return  date.formatDate()
        }
        return "Ошибка"
    }
    
    func daysInMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return calendar.range(of: .day, in: .month, for: date)!.count
    }
}

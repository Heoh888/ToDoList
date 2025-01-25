//
//  DatePickerExample.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 23.01.2025.
//

import SwiftUI

struct DatePickerView: View {
    
    let dateString: String

    @State var viewModel = DatePickerViewModel()
    
    // Настройки диапазона
    private let yearsRange = (1900...2100)
    private let monthsRange = Array(1...12)
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                // Выбор дня
                Picker("День", selection: $viewModel.selectedDay) {
                    ForEach(1...viewModel.daysInMonth(month: viewModel.selectedMonth,
                                                      year: viewModel.selectedYear), id: \.self) { day in
                        Text("\(day)").tag(day)
                            .foregroundStyle(Color.customYellow)
                    }
                }
                .pickerStyle(.inline)
                .frame(width: 100, height: 100)
                .clipped()
                
                // Выбор месяца
                Picker("Месяц", selection: $viewModel.selectedMonth) {
                    ForEach(monthsRange, id: \.self) { month in
                        Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                            .foregroundStyle(Color.customYellow)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 150, height: 100)
                .clipped()
                
                // Выбор года
                Picker("Год", selection: $viewModel.selectedYear) {
                    ForEach(yearsRange, id: \.self) { year in
                        Text("\(year)").tag(year)
                            .foregroundStyle(Color.customYellow)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 100)
                .clipped()
            }
            .padding(.vertical, 30)
        }
        .background(.black)
        .cornerRadius(15)
        .onAppear {
            viewModel.setDate(from: dateString)
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(dateString: Date().formatDate())
    }
}

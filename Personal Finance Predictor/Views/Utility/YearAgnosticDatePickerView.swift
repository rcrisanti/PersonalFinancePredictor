//
//  YearAgnosticDatePickerView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/22/21.
//

import SwiftUI

struct YearAgnosticDatePickerView: View {
//    @Binding var date: Date
    @State private var date = Date()
    @State private var monthIndex = 0 {
        didSet {
            print("didSet monthIndex")
            let components = DateComponents(month: oldValue, day: dayIndex)
            date = Calendar.current.date(from: components)!
        }
    }
    @State private var dayIndex = 0 {
        willSet {
            print("willSet dayIndex")
            let components = DateComponents(month: monthIndex, day: newValue)
            date = Calendar.current.date(from: components) ?? Date()
        }
    }
    
    let monthRange: Range<Int> = Calendar.current.maximumRange(of: .month) ?? 0..<13
    let dayRange: Range<Int> = Calendar.current.maximumRange(of: .day) ?? 0..<31
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    var body: some View {
        Group {
            Picker("Month", selection: $monthIndex) {
                ForEach(monthRange) {
                    Text(getMonthName(ofMonthNumber: $0))
                }
            }
            
            Picker("Day", selection: $dayIndex) {
                ForEach(dayRange) {
                    Text("\($0)")
                }
            }
            
            Text("Day: \(formatter.string(from: date))")
        }
    }
    
    func getMonthName(ofMonthNumber: Int) -> String {
        let components = DateComponents(month: ofMonthNumber)
        print(components)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        return formatter.string(from: Calendar.current.date(from: components) ?? Date())
        
    }
}

struct YearAgnosticDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            YearAgnosticDatePickerView(date: .constant(Date()))
            YearAgnosticDatePickerView()
        }
    }
}

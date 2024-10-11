//
//  Date+Extension.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 11/10/24.
//

import SwiftUI


extension Date {
    var startOfMonth: Date {
        let calendar = Calendar.current
        
        let component = calendar.dateComponents([.year, .month], from: self)
        
        return calendar.date(from: component) ?? self
    }
    
    var endOfMonth: Date {
        let calendar = Calendar.current

        return calendar.date(byAdding: .init(month: 1, minute: -1), to: startOfMonth) ?? self
    }
    
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

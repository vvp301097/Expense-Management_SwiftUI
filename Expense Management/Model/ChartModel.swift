//
//  ChartModel.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 15/10/24.
//

import SwiftUI

struct ChartGroup: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var categories: [ChartCategory]
    var totalIncome: Double
    var totalExpense: Double
}

struct ChartCategory: Identifiable {
    var id: UUID = UUID()
    var totalValue: Double
    var category: Category
}

//
//  Transaction.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 11/10/24.
//

import SwiftUI
import SwiftData

@Model
class Transaction {
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var category: String
    var tintColor: String
    
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    //Extract Color value from tintColor String
    @Transient
    var color: Color {
        return tints.first(where: { $0.color == tintColor })?.value ?? appTint
    }
    
    @Transient
    var tint: TintColor? {
        return tints.first(where: { $0.color == tintColor })
    }
    @Transient
    var rawCategory: Category? {
        return Category.allCases.first(where: { $0.rawValue == category })
    }
}


// Example Transactions:

//var sampleTransactions: [Transaction] = [
//    .init(title: "Magic Keyboard", remarks: "Apple Product", amount: 129, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
//    .init(title: "Apple Watch", remarks: "Apple Product", amount: 123, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
//    .init(title: "Apple TV", remarks: "Apple Product", amount: 333, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
//    .init(title: "Apple CarPlay", remarks: "Apple Product", amount: 444, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
//    .init(title: "Apple", remarks: "Food", amount: 555, dateAdded: .now, category: .income, tintColor: tints.randomElement()!),
//    .init(title: "Apple", remarks: "Food", amount: 666, dateAdded: .now, category: .income, tintColor: tints.randomElement()!),
//    
//]

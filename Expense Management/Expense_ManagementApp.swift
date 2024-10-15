//
//  Expense_ManagementApp.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 10/10/24.
//

import SwiftUI

@main
struct Expense_ManagementApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Transaction.self])
    }
}

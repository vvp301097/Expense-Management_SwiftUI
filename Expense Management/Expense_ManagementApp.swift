//
//  Expense_ManagementApp.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 10/10/24.
//

import SwiftUI
import WidgetKit

@main
struct Expense_ManagementApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .onChange(of: scenePhase) { oldValue, newValue in
                    switch newValue {
                    case .background:
                        WidgetCenter.shared.reloadAllTimelines()
                        break
                    default:
                        break
                    }
                }
        }
        .modelContainer(for: [Transaction.self])
    }
}

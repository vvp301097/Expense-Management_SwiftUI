//
//  Tab.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 10/10/24.
//
import SwiftUI

enum Tab: String, CaseIterable {
    case recents = "Recents"
    case search = "Search"
    case charts = "Charts"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
            case .recents:
            Image(systemName: "calendar")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)

        case .charts:
            Image(systemName: "chart.bar.xaxis")
            Text(self.rawValue)

        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)

        }
    }
}

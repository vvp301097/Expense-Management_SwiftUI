//
//  ContentView.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 10/10/24.
//

import SwiftUI

struct ContentView: View {
    
    // Intro Visibility Status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var activeTab: Tab = .recents
    var body: some View {
       
        TabView(selection: $activeTab) {
            RecentsView()
                .tag(Tab.recents)
                .tabItem { Tab.recents.tabContent }
            SearchView()
                .tag(Tab.search)
                .tabItem { Tab.search.tabContent }
            GraphsView()
                .tag(Tab.charts)
                .tabItem { Tab.charts.tabContent }
            SettingsView()
                .tag(Tab.settings)
                .tabItem { Tab.search.tabContent }
                
        }
        .sheet(isPresented: $isFirstTime) {
            IntroScreen()
                .interactiveDismissDisabled()
        }
        
    }
}

#Preview {
    ContentView()
}

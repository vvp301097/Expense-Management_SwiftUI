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
            Text("Recents")
                .tag(Tab.recents)
                .tabItem { Tab.recents.tabContent }
            Text("Search")
                .tag(Tab.search)
                .tabItem { Tab.search.tabContent }
            Text("Chart")
                .tag(Tab.charts)
                .tabItem { Tab.charts.tabContent }
            Text("Settings")
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

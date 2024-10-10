//
//  IntroScreen.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 10/10/24.
//

import SwiftUI

struct IntroScreen: View {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            Text("What's New in the Expense Management")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            // Points View
            
            VStack(alignment: .leading, spacing: 25) {
                PointView(symbol: "dollarsign", title: "Transactions", subtitle: "Keep track of your earnings and expenses.")
                
                PointView(symbol: "chart.bar.fill", title: "Visual Charts", subtitle: "View your transactions using eye-catching graphic representations.")
                PointView(symbol: "magnifyingglass", title: "Advanced Filters", subtitle: "Find the expenses you need to track quickly and easily.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            Spacer(minLength: 10)
            
            Button {
                isFirstTime = false
            } label: {
                Text("Get Started")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(appTint.gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
            }

        }
        .padding(15)
    }
    
    
    @ViewBuilder
    func PointView(symbol: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint.gradient)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    IntroScreen()
}

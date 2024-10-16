//
//  CardView.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 11/10/24.
//

import SwiftUI

struct CardView: View {
    
    var income: Double
    var expense: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text("\((income - expense).currencyString())")
                        .font(.title.bold())
                        .foregroundStyle(Color.primary)
                    
                    Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundStyle(expense > income ? .red : .green)
                }
                .padding(.bottom, 24)
                
                HStack(spacing: 0) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        let symbolImage = category == .income ? "arrow.down" : "arrow.up"
                        let tint = category == .income ? Color.green : .red
                        
                        HStack(spacing: 8) {
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(tint)
                                .frame(width: 35, height: 35)
                                .background {
                                    Circle().fill(tint.opacity(0.25).gradient)
                                }
                            
                            VStack(spacing: 4) {
                                Text("\(category.rawValue.capitalized)")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                Text( (category == .income ? income : expense).currencyString(allowedDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.primary)
                                
                                
                            }
                             
                            if category == .income {
                                Spacer(minLength: 8)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 24)
            .padding(.top, 16)
            
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 3333, expense: 4444)

    }
}

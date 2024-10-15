//
//  TransactionCardView.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 11/10/24.
//

import SwiftUI

struct TransactionCardView: View {
    @Environment(\.modelContext) private var context
    
    var transaction: Transaction
    
    var showsCategory: Bool = false
    var body: some View {
        SwipeAction(cornerRadius: 8, direction: .trailing) {
            HStack(spacing: 12) {
                Text(transaction.title.prefix(1))
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(transaction.color.gradient, in: .circle)
                
                VStack(alignment: .leading) {
                    Text(transaction.title)
                        .foregroundStyle(.primary)
                    
                    Text("\(transaction.remarks)")
                        .font(.caption)
                        .foregroundStyle(.primary.secondary)
                    
                    Text(transaction.dateAdded.format("dd MMM yyyy"))
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    if showsCategory {
                        Text(transaction.category)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .foregroundStyle(.white)
                            .background(transaction.category == Category.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
                    }
                }
                .lineLimit(1)
                .hSpacing(.leading)
                
                Text(transaction.amount.currencyString(allowedDigits: 2))
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.background, in: .rect(cornerRadius: 8))
        } actions: {
            Action(tint: .red, icon: "trash") {
                context.delete(transaction)
            }
        }

    }
}

//#Preview {
//    TransactionCardView(transaction: sampleTransactions.first!)
//}

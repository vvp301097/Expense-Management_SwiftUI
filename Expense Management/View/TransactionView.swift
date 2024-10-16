//
//  NewExpensiveView.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 14/10/24.
//

import SwiftUI
import WidgetKit

struct TransactionView: View {
    // Edit transaction
    var editTransaction: Transaction?
    // Env properties
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    // View Properties
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = 0
    @State private var dateAdded: Date = .now
    @State private var category: Category = .income
    // Random Tint
    @State var tint: TintColor = tints.randomElement()!
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                // Preview Transaction Card View
                TransactionCardView(transaction: Transaction(title: title.isEmpty ? "Title" : title, remarks: remarks.isEmpty ? "Remarks" : remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint))
                
                //
                CustomSection("Title", "Magic Keyboard", value: $title)
                
                CustomSection("Remarks", "Apple Product!", value: $remarks)

                // Amount & Category check box
                VStack(alignment: .leading, spacing: 10) {
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Text(currencySymbol)
                                .font(.callout.bold())
                            
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.decimalPad)

                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .frame(maxWidth: 130)
                    
                        CustomCheckBox()
                    }
                }
                
                // Date picker
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .tint(appTint)
                    
                }
            }
            .padding(16)
        }
        .navigationTitle("\(editTransaction != nil ? "Edit" : "Add") Transaction")
        .background(.gray.opacity(0.15))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveTransaction()
                }
            }
        }
        .onAppear {
            if let editTransaction {
                title = editTransaction.title
                remarks = editTransaction.remarks
                amount = editTransaction.amount
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory {
                    self.category = category

                }
                if let tint = editTransaction.tint {
                    self.tint = tint
                }
                
            }
        }
    }
    
    //Save transaction
    func saveTransaction() {
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.dateAdded = dateAdded
            editTransaction?.category = category.rawValue
            editTransaction?.tintColor = tint.color
        } else {
            let transaction = Transaction(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            modelContext.insert(transaction)
        }
        
        dismiss()
        
        WidgetCenter.shared.reloadAllTimelines()

    }
    
    
    @ViewBuilder
    func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            
            TextField(hint, text: value)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        }
    }
    
    @ViewBuilder
    func CustomCheckBox() -> some View {
        HStack(spacing: 10) {
            ForEach(Category.allCases, id:\.rawValue) { category in
                HStack(spacing: 5) {
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTint)
                        }
                                                    
                    }
                    Text(category.rawValue)
                        .font(.caption)
                    

                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }
    
    
    // Number formater
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    NavigationStack {
        TransactionView()
    }
}

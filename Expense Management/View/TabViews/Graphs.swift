//
//  Graphs.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 11/10/24.
//

import SwiftUI
import Charts
import SwiftData

struct GraphsView: View {
    
    @Query(animation: .snappy) private var transactions: [Transaction]
    @State private var chartGroups: [ChartGroup] = []
    var body: some View {
        NavigationStack{
            ScrollView(.vertical) {
                LazyVStack {
                    ChartView()
                        .frame(height: 200)
                        .padding(10)
                        .padding(.top, 10)
                        .background(.background, in: .rect(cornerRadius: 10))
                    
                    ForEach(chartGroups.reversed()) { group in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(group.date.format("MMM yyyy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                            
                            NavigationLink {
                                ListOfExpenses(month: group.date)
                            } label: {
                                CardView(income: group.totalIncome, expense: group.totalExpense)

                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .onAppear {
                createChartGroups()
            }
        }
        
    }
    
    @ViewBuilder
    func ChartView() -> some View {
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.categories) { chart in
                    BarMark(
                        x: .value("Month", group.date.format("MMM yyyy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                AxisGridLine()
                AxisTick()
                
                
                AxisValueLabel {
                    Text(axisLabel(doubleValue))
                }
                
                
            }
        }
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }
    
    func createChartGroups() {
        Task.detached(priority: .high) {
            let calender = Calendar.current
            let groupedByDate = await Dictionary(grouping: transactions) { transaction in
                let components = calender.dateComponents([.month, .year], from: transaction.dateAdded)
                
                return components
            }
            
            let sortedGroups = groupedByDate.sorted {
                let date1 = calender.date(from: $0.key) ?? Date()
                let date2 = calender.date(from: $1.key) ?? Date()
                
                return calender.compare(date1, to: date2, toGranularity:.day) == .orderedAscending
            }
            
            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
                let date = calender.date(from: dict.key) ?? Date()
                let income = dict.value.filter({$0.category == Category.income.rawValue })
                let expense = dict.value.filter({$0.category == Category.expense.rawValue })
                
                let incomeTotalValue = total(income, category: .income)
                let expenseTotalValue = total(expense, category: .expense)
                
                return .init(date: date, categories: [ .init(totalValue: incomeTotalValue, category: .income), .init(totalValue: expenseTotalValue, category: .expense)], totalIncome: incomeTotalValue, totalExpense: expenseTotalValue)
            }
            
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        
        return intValue < 1000 ? "\(intValue)" : "\(kValue)K"
    }
}


// List of transactions for the selected month

struct ListOfExpenses: View {
    var month: Date
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                Section {
                    FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .income) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                        }
                    }
                } header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
                
                Section {
                    FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .expense) { transactions in
                        ForEach(transactions) { transaction in
                            NavigationLink {
                                TransactionView(editTransaction: transaction)
                            } label: {
                                TransactionCardView(transaction: transaction)
                            }
                        }
                    }
                } header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
                
            }
            .buttonStyle(.plain)
            .padding(16)
        }
        .background(.gray.opacity(0.15))
        .navigationTitle(month.format("MMM yyyy"))
       
    }
}

#Preview {
    GraphsView()
}

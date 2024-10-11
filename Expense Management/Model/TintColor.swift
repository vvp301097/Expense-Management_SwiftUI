//
//  TintColor.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 11/10/24.
//
import SwiftUI

struct TintColor: Identifiable {
    let id: UUID = UUID()
    
    var color: String
    
    var value: Color
}

var tints: [TintColor] = [
    .init(color: "Red", value: .red),
    .init(color: "Blue", value: .blue),
    .init(color: "Pink", value: .pink),
    .init(color: "Puple", value: .purple),
    .init(color: "Brown", value: .brown),
    .init(color: "Orange", value: .orange)
]

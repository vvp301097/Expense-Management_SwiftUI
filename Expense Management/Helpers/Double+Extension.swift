//
//  String+Extension.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 11/10/24.
//
//

import Foundation

extension Double {
    func currencyString(allowedDigits: Int = 2) -> String {
        let formattedNumber = NumberFormatter()
        
        formattedNumber.numberStyle = .currency
        formattedNumber.maximumFractionDigits = allowedDigits
        
        return formattedNumber.string(from: NSNumber(value: self)) ?? ""
    }
}

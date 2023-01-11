//
//  Extension + Decimal.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 19/10/22.
//

import Foundation

extension Decimal {
    func asMoney() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        
        return formatter.string(from: self as NSDecimalNumber) ?? "N/D"
    }
}

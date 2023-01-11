//
//  Extension + Double.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 27/10/22.
//

import UIKit

extension Double {
    public func asString(digits: Int = 2, minimum: Int = 2) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.decimalSeparator = ","
        currencyFormatter.minimumFractionDigits = minimum
        currencyFormatter.maximumFractionDigits = digits
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        let formattedNumber = NSNumber(value: self)
        guard let priceString = currencyFormatter.string(from: formattedNumber) else {return ""}
        return "\(priceString)"
    }
    
    public func asMoney(digits: Int = 2, minimum: Int = 2) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.decimalSeparator = ","
        currencyFormatter.minimumFractionDigits = minimum
        currencyFormatter.maximumFractionDigits = digits
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        let formattedNumber = NSNumber(value: self)
        guard let priceString = currencyFormatter.string(from: formattedNumber) else {return ""}
        return "\(priceString)"
    }
}

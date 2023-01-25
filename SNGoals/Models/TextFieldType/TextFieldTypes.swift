//
//  TextFieldTypes.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 24/01/23.
//

import UIKit

enum TextFieldTypes {
    case text
    case currency
    case percent
    case number
}

extension TextFieldTypes {
    func keyboard() -> UIKeyboardType {
        switch self {
        case .text:
            return .default
        case .currency:
            return .decimalPad
        case .percent:
            return .numberPad
        case .number:
            return .decimalPad
        }
    }
}

//
//  Validator.swift
//  Template
//
//  Created by Matheus D Sanada on 04/01/22.
//

import Foundation

/// Enums that represents all validations formats.
enum Validator {
    case equal(count: Int)
    case equalMore(count: Int)
    case contains(string: String)
    case email
}

extension Validator {
    /// validate enum logic.
    func validate(_ text: String) -> Bool {
        switch self {
        case let .equal(count):
            return validate(text, equal: count)
        case let .equalMore(count):
            return validate(text, equalMore: count)
        case .contains(let element):
            return contains(text, contains: element)
        case .email:
            return regex(text, REGEX: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
        }
    }
}

extension Validator {
    /// Function validate `String` count `Equal` to an `Int`.
    fileprivate func validate(_ string: String, equal count: Int) -> Bool {
        return string.count == count
    }

    /// Function validate `String` count `More or Equal` to an `Int`.
    fileprivate func validate(_ string: String, equalMore count: Int) -> Bool {
        return string.count >= count
    }
    
    /// Function contains `String`.
    fileprivate func contains(_ string: String, contains: String) -> Bool {
        return string.contains(contains)
    }
    
    /// Functiion validate `String` with `REGEX`.
    fileprivate func regex(_ string: String, REGEX: String) -> Bool  {
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: string)
    }
}

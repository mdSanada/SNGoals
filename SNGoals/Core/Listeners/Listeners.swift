//
//  Listeners.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 27/10/22.
//

import Foundation
import InputMask

enum Listeners {
    case birthdate
    case limit(quantity: Int)
    case limitLetters(quantity: Int)
    case cellphone
    case digits
    case alphabetic
    case none
    case onlyDigits(quantity: Int)
}

extension MaskedTextInputListener {
    static func returnLimit(quantity: Int) -> String {
        let str = String(repeating: "N", count: quantity)
        return "[\(str)]"
    }
    
    static func listener(_ type: Listeners, delegate: NSObject? = nil, listener: OnMaskedTextChangedListener? = nil) -> MaskedTextInputListener {
        let theListr = createListener(type)
        theListr.delegate = delegate
        theListr.listener = listener
        return theListr
    }
    
    static func createListener(_ listener: Listeners) -> MaskedTextInputListener {
        switch listener {
        case .birthdate:
            return birthdate()
        case .limit(let quantity):
            return limit(quantity)
        case .limitLetters(let quantity):
            return limitLetters(quantity)
        case .cellphone:
            return cellphone()
        case .digits:
            return digits()
        case .alphabetic:
            return alphabetic()
        case let .onlyDigits(quantity):
            return onlyDigits(quantity: quantity)
        case .none:
            return  .init(
                primaryFormat: "[_…]",
                autocomplete: false,
                autocompleteOnFocus: false,
                rightToLeft: false,
                customNotations: [notation])
        }
    }
}

//MARK: -- Construtores dos listeners
fileprivate func onlyDigits(quantity: Int) -> MaskedTextInputListener {
    let format = String.init(repeating: "0", count: quantity)
    return .init(primaryFormat: "[\(format)]",
                 autocomplete: false,
                 autocompleteOnFocus: false,
                 autoskip: true,
                 rightToLeft: false,
                 affinityCalculationStrategy: .extractedValueCapacity,
                 customNotations: []
    )
}

fileprivate func birthdate() -> MaskedTextInputListener {
    return .init(primaryFormat: "[00]/[00]/[0000]",
                 autocomplete: true,
                 autocompleteOnFocus: false,
                 autoskip: true,
                 rightToLeft: false,
                 affinityCalculationStrategy: .extractedValueCapacity,
                 customNotations: []
    )
}

fileprivate func limit(_ quantity: Int) -> MaskedTextInputListener {
    return  .init(
        primaryFormat: MaskedTextInputListener.returnLimit(quantity: quantity),
        autocomplete: false,
        autocompleteOnFocus: false,
        rightToLeft: false,
        customNotations: [notation])
}

fileprivate func limitDigits(_ quantity: Int) -> MaskedTextInputListener {
    return  .init(
        primaryFormat: MaskedTextInputListener.returnLimit(quantity: quantity),
        autocomplete: false,
        autocompleteOnFocus: false,
        rightToLeft: false,
        customNotations: [digitsNotation])
}

fileprivate func limitLetters(_ quantity: Int) -> MaskedTextInputListener {
    return  .init(
        primaryFormat: MaskedTextInputListener.returnLimit(quantity: quantity),
        autocomplete: false,
        autocompleteOnFocus: false,
        rightToLeft: false,
        customNotations: [lettersNotation])
}

fileprivate func cellphone() -> MaskedTextInputListener {
    return .init(
        primaryFormat: "([00]) [0] [0000]-[0000]",
        autocomplete: true,
        autocompleteOnFocus: false,
        autoskip: true,
        rightToLeft: false,
        affineFormats: ["([00]) [0000]-[0000]"],
        affinityCalculationStrategy: .extractedValueCapacity,
        customNotations: [])
}

fileprivate func digits() -> MaskedTextInputListener {
    return .init(
        primaryFormat: "[0…]",
        autocomplete: true,
        autocompleteOnFocus: false,
        autoskip: true,
        rightToLeft: true,
        customNotations: [])
}

fileprivate func alphabetic() -> MaskedTextInputListener {
    let mask = "[N…]"
    return .init(primaryFormat: mask,
                 autocomplete: true,
                 autocompleteOnFocus: false,
                 rightToLeft: false,
                 affineFormats: [mask],
                 affinityCalculationStrategy: .wholeString,
                 customNotations: [alphabeticNotation])
}

private var digitsNotation: Notation {
    return .init(
        character: "N",
        characterSet: CharacterSet.decimalDigits,
        isOptional: false)
}

private var lettersNotation: Notation {
    return .init(
        character: "N",
        characterSet: CharacterSet.letters,
        isOptional: false)
}

private var notation: Notation {
    return .init(
        character: "N",
        characterSet: CharacterSet.symbols
            .union(CharacterSet.decimalDigits)
            .union(CharacterSet.letters)
            .union(CharacterSet.punctuationCharacters)
            .union(CharacterSet.whitespaces),
        isOptional: false)
}

private var alphabeticNotation: Notation {
    return .init(
        character: "N",
        characterSet: CharacterSet.symbols
            .union(CharacterSet.letters)
            .union(CharacterSet.whitespaces),
        isOptional: false)
}


//
//  ACViewModelProtocol.swift
//  Sanada
//
//  Created by sanada on 22/03/22.
//

import Foundation

public protocol SNViewModelProtocol {
    associatedtype States = SNStateful
    func emit(_ state: States)
}


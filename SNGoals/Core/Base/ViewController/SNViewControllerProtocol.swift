//
//  ViewControllerProtocol.swift
//  Sanada
//
//  Created by sanada on 22/03/22.
//

import Foundation

public protocol SNViewControllerProtocol {
    associatedtype States = SNStateful
    func render(states: States)
}

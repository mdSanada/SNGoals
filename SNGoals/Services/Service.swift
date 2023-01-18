//
//  Service.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation

enum Service: ServiceProtocol {
    case goals
}

extension Service {
    var collection: String {
        switch self {
        case .goals:
            return "GOALS"
        }
    }
}

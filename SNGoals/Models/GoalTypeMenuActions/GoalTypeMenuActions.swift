//
//  GoalTypeMenuActions.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 24/02/23.
//

import UIKit

enum GoalTypeMenuActions: CaseIterable {
    case simple
    case currency
    case number
}

extension GoalTypeMenuActions {
    func title() -> String {
        switch self {
        case .simple:
            return "Criar uma nova meta"
        case .currency:
            return "Criar uma nova meta (R$)"
        case .number:
            return "Criar uma nova meta (00)"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .simple:
            return UIImage(systemName: "slider.horizontal.below.square.filled.and.square")
        case .currency:
            return UIImage(systemName: "dollarsign.square")
        case .number:
            return UIImage(systemName: "123.rectangle")
        }
    }
    
    func attributes() -> UIMenuElement.Attributes {
        switch self {
        case .simple:
            return []
        case .currency:
            return []
        case .number:
            return []
        }
    }

}

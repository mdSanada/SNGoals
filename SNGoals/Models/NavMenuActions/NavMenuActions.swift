//
//  NavMenuActions.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import UIKit

enum NavMenuActions: CaseIterable {
    case edit
    case share
    case delete
}

extension NavMenuActions {
    func title() -> String {
        switch self {
        case .edit:
            return "Editar"
        case .share:
            return "Compartilhar"
        case .delete:
            return "Deletar"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .edit:
            return UIImage(systemName: "square.and.pencil")
        case .share:
            return UIImage(systemName: "shareplay")
        case .delete:
            return UIImage(systemName: "trash")
        }
    }
    
    func attributes() -> UIMenuElement.Attributes {
        switch self {
        case .edit:
            return []
        case .share:
            return []
        case .delete:
            return .destructive
        }
    }

}

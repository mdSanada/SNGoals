//
//  Extension + Table.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 13/09/22.
//

import UIKit
import SnapKit

public extension UITableView {
    func register(type: UITableViewCell.Type) {
        let identifier = type.reuseIdentifier
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<Type: UITableViewCell> (_ indexPath: IndexPath) -> Type {
        return dequeueReusableCell(
            withIdentifier: Type.self.reuseIdentifier,
            for: indexPath) as! Type
    }
}

public extension UITableViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
}

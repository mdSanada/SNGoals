//
//  CollectionTextFieldProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

protocol CollectionTextFieldProtocol {
    func collectionViewCell(changed value: String?, from indexPath: IndexPath)
}

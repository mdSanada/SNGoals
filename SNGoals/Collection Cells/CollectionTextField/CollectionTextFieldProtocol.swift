//
//  CollectionTextFieldProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

protocol CollectionTextFieldProtocol: AnyObject {
    func collectionViewCell(_ cell: TextFieldCollectionViewCell, changed value: String?, from indexPath: IndexPath)
    func collectionViewCell(_ cell: TextFieldCollectionViewCell, isValid: Bool, from indexPath: IndexPath)
}

//
//  CollectionTextFieldProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

protocol CollectionDateProtocol: AnyObject {
    func collectionViewCell(_ cell: DateCollectionViewCell, changed date: Date?, from indexPath: IndexPath)
    func collectionViewCell(_ cell: DateCollectionViewCell, isValid: Bool, from indexPath: IndexPath)
}

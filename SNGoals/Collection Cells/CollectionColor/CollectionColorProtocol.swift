//
//  CollectionTextFieldProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

protocol CollectionColorProtocol {
    func collectionViewCell(_ cell: ColorCollectionViewCell, changed color: String?, from indexPath: IndexPath)
}

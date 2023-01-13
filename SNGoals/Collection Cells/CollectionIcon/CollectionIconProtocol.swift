//
//  CollectionTextFieldProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

protocol CollectionIconProtocol: AnyObject {
    func collectionViewCell(_ cell: IconCollectionViewCell, changed icon: String?, from indexPath: IndexPath)
}

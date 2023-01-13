//
//  CollectionTextFieldProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

protocol CollectionDateProtocol: AnyObject {
    func collectionViewCell(changed date: Date?, from indexPath: IndexPath)
}

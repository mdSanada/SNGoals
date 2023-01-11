//
//  CollectionHeaderProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 10/01/23.
//

import UIKit

protocol CollectionHeaderProtocol: AnyObject {
    func collectionViewHeader(changed menu: String, from indexPath: IndexPath)
}

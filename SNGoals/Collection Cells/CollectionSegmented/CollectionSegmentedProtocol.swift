//
//  CollectionSegmentedProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

protocol CollectionSegmentedProtocol: AnyObject {
    func collectionViewCell(changed segment: Int?, from indexPath: IndexPath)
}

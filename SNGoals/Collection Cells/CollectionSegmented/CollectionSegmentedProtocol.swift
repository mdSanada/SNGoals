//
//  CollectionSegmentedProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import UIKit

protocol CollectionSegmentedProtocol: AnyObject {
    func collectionViewCell(_ cell: SegmentedCollectionViewCell, changed segment: Int?, from indexPath: IndexPath)
    func collectionViewCell(_ cell: SegmentedCollectionViewCell, isValid: Bool, from indexPath: IndexPath)

}

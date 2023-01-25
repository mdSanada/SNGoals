//
//  CreateGoalsCollectionInteractor.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 11/01/23.
//

import Foundation

protocol CreateGoalsCollectionInteractor: AnyObject {
    func collectionView(_ collectionView: CreateGoalsCollectionView, didChange color: HEXColor)
    func collectionView(_ collectionView: CreateGoalsCollectionView, didChange segmented: GoalType, at indexPath: IndexPath)
}

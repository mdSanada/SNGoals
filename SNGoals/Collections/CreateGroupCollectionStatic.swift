//
//  CreateGroupCollectionStatic.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 11/01/23.
//

import UIKit

struct CreateGroupCollection {
    struct Icon {
        static let identifier = "Icon"
        static let nib = "IconCollectionViewCell"
    }
    
    struct Color {
        static let identifier = "Color"
        static let nib = "ColorCollectionViewCell"
    }
    
    struct Date {
        static let identifier = "Date"
        static let nib = "DateCollectionViewCell"
    }
    
    struct Text {
        static let identifier = "TextField"
        static let nib = "TextFieldCollectionViewCell"
    }
    
    struct Segmented {
        static let identifier = "Segmented"
        static let nib = "SegmentedCollectionViewCell"
    }
    
    struct Header {
        static let identifier = "CollectionHeader"
        static let element = UICollectionView.elementKindSectionHeader
    }
}


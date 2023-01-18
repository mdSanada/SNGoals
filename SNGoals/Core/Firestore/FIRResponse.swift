//
//  FIRResponse.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 17/01/23.
//

import Foundation

protocol FirestoreModel {
    var uuid: FirestoreId? { get set }
}

typealias FIRResponse = FirestoreModel & Codable


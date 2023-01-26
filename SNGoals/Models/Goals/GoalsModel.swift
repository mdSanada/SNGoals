//
//  GoalsModel.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation

// MARK: - GoalsModel
struct GoalsModel: FIRResponse {
    var uuid: FirestoreId?
    let name: String?
    let color: HEXColor?
    let iconGroup, icon: String?
    let owner: FirestoreId?
    let shared: [FirestoreId]?
    let creationDate, date: Date?
    let goals: [FirestoreId]?
    var updatedDate: String? = nil

    enum CodingKeys: String, CodingKey {
        case uuid, name, color, date
        case iconGroup = "icon-group"
        case icon, owner, shared
        case creationDate = "creation-date"
        case updatedDate = "updated-date"
        case goals
    }
}

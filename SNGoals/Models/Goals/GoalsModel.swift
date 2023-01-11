//
//  GoalsModel.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation

// MARK: - GoalsModel
struct GoalsModel: Codable {
    let uuid: FirestoreId?
    let name, color: String?
    let iconGroup, icon: String?
    let owner: FirestoreId?
    let shared: [FirestoreId]?
    let creationDate, date: Date?
    let goals: [FirestoreId]?

    enum CodingKeys: String, CodingKey {
        case uuid, name, color, date
        case iconGroup = "icon-group"
        case icon, owner, shared
        case creationDate = "creation-date"
        case goals
    }
}

//
//  GoalModel.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation

// MARK: - GoalModel
struct GoalModel: Codable {
    let uuid: FirestoreId?
    let name, type: String?
    let value, goal: Double?
    let iconGroup, icon: String?
    let creationDate: Date?

    enum CodingKeys: String, CodingKey {
        case uuid, name, type, value, goal
        case iconGroup = "icon-group"
        case creationDate = "creation-date"
        case icon
    }
}

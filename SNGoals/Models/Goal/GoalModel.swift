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

extension GoalModel {
    func stringValue() -> String? {
        if self.type == "MONEY" {
            return self.value?.asString(digits: 0)
        } else {
            return self.value?.asMoney(digits: 2)
        }
    }
    
    func stringGoal() -> String? {
        if self.type == "MONEY" {
            return self.goal?.asString(digits: 0)
        } else {
            return self.goal?.asMoney(digits: 2)
        }
    }
    
    func percentage() -> Double {
        return (self.value ?? 0) / (self.goal ?? 1)
    }
    
    func stringPercentage() -> String {
        let percentage = (percentage() * 10000).asString(digits: 0).percentFormatting(digits: 0, minimum: 0)
        let defaultPercentage = "0".percentFormatting(digits: 0, minimum: 0)
        return percentage == "" ? defaultPercentage : percentage
    }
}

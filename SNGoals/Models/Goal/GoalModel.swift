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
    let name: String?
    let type: GoalType?
    let value, goal: Double?
    let iconGroup, icon: String?
    var updatedDate: String? = nil
    let creationDate: String?

    enum CodingKeys: String, CodingKey {
        case uuid, name, type, value, goal
        case iconGroup = "icon-group"
        case creationDate = "creation-date"
        case updatedDate = "updated-date"
        case icon
    }
}

extension GoalModel {
    func stringValue() -> String? {
        switch type {
        case .money:
            return self.value?.asMoney(digits: 2)
        case .number:
            return self.value?.asString(digits: 0)
        case .simple:
            return self.value?.asString(digits: 0)
        case .none:
            return nil
        }
    }
    
    func stringGoal() -> String? {
        switch type {
        case .money:
            return self.goal?.asMoney(digits: 2)
        case .number:
            return self.goal?.asString(digits: 0)
        case .simple:
            return self.goal?.asString(digits: 0)
        case .none:
            return nil
        }
    }
    
    func percentage() -> Double {
        switch type {
        case .number:
            return (self.value ?? 0) / (self.goal ?? 1).rounded(.down)
        case .money:
            return (self.value ?? 0) / (self.goal ?? 1)
        case .simple:
            return (self.value ?? 0) / (self.goal ?? 1)
        default:
            return .greatestFiniteMagnitude
        }
    }
    
    func stringPercentage() -> String {
        let percentage = (percentage() * 10000).asString(digits: 0).percentFormatting(digits: 0, minimum: 0)
        let defaultPercentage = "0".percentFormatting(digits: 0, minimum: 0)
        return percentage == "" ? defaultPercentage : percentage
    }
}

//
//  CreateGoalRequest.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 20/01/23.
//

import Foundation

struct CreateGoalRequest: Codable {
    var name: String?
    var type: String?
    var value, goal: Double?
    var iconGroup, icon: String?
    let creationDate: String? = Date().string(pattern: .api)

    enum CodingKeys: String, CodingKey {
        case name, type, value, goal
        case iconGroup = "icon-group"
        case creationDate = "creation-date"
        case icon
    }
}

extension CreateGoalRequest {
    func create(with uuid: FirestoreId) -> GoalModel {
        GoalModel(uuid: uuid,
                  name: self.name,
                  type: GoalType(rawValue: self.type ?? ""),
                  value: self.value,
                  goal: self.goal,
                  iconGroup: self.iconGroup,
                  icon: self.icon,
                  creationDate: self.creationDate)
    }
}

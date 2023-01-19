//
//  CreateGoalsRequest.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 10/01/23.
//

import Foundation

struct CreateGoalsRequest: Codable {
    var name: String?
    var color: HEXColor?
    var iconGroup, icon: String?
    var owner: FirestoreId? = nil
    var shared: [FirestoreId]? = []
    let creationDate: String = Date().string(pattern: .api)
    var date: String?
    let goals: [FirestoreId] = []

    enum CodingKeys: String, CodingKey {
        case name, color, date
        case iconGroup = "icon-group"
        case icon, owner, shared
        case creationDate = "creation-date"
        case goals
    }
}

extension CreateGoalsRequest {
    func create(with uuid: FirestoreId) -> GoalsModel {
        GoalsModel(uuid: uuid,
                   name: self.name,
                   color: self.color,
                   iconGroup: self.iconGroup,
                   icon: self.icon,
                   owner: self.owner,
                   shared: self.shared,
                   creationDate: self.creationDate.date(),
                   date: self.date?.date(),
                   goals: self.goals)
    }
}

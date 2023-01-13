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
    var owner: FirestoreId?
    var shared: [FirestoreId]?
    let creationDate = Date()
    var date: Date?
    let goals: [FirestoreId] = []

    enum CodingKeys: String, CodingKey {
        case name, color, date
        case iconGroup = "icon-group"
        case icon, owner, shared
        case creationDate = "creation-date"
        case goals
    }
}

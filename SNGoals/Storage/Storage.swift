//
//  Storage.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation

struct Storage {
    static var shared = Storage()
    
    public var goals: [GoalsModel] = [] {
        didSet {
//            SNNotificationCenter.post(notification: SNNotificationCenter.goals.notification,
//                                      arguments: ["key": "goals"])
        }
    }
}
//
//  Storage.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation

struct Storage {
    static var shared = Storage()
    
    public var goals: [String] = [] {
        didSet {
//            SNNotificationCenter.post(notification: SNNotificationCenter.materials.notification, arguments: ["key": "goals"])
        }
    }
}

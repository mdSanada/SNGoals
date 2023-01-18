//
//  NotificationCenter.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 29/10/22.
//

import Foundation

public class SNNotificationCenter: NSObject {
    static public let shared = NotificationCenter.init()
    
    static public let goals = SNNotificationModel(notification: "Firestore.fetch.goals")
    
    public static func post(notification: Notification, arguments: [String: Any]) {
        SNNotificationCenter.shared.post(name: notification.name,
                                         object: nil,
                                         userInfo: arguments)
    }
}

public struct SNNotificationModel {
    public let name: Notification.Name
    public let notification: Notification
    
    init(notification: String) {
        self.name = Notification.Name(notification)
        self.notification = Notification(name: name)
    }
}

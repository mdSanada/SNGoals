//
//  MockHelper.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 06/01/23.
//

import Foundation

struct MockHelper {
    private static var goal: [GoalModel] = []
    
    static func createGoals() -> [GoalsModel] {
        var result: [GoalsModel] = []
        for index in 1...10 {
            let owner = UUID().uuidString
            let goals = GoalsModel(uuid: owner,
                       name: "Group \(index)",
                       color: randomColor(),
                       iconGroup: "Human",
                       icon: "figure.mind.and.body",
                       owner: owner,
                       shared: [],
                       creationDate: Date(),
                       date: Date(),
                       goals: createGoal().map { $0.uuid ?? "" })
            result.append(goals)
        }

        return result
    }
    
    static func createGoal() -> [GoalModel] {
        if !goal.isEmpty {
            return goal
        }
        var result: [GoalModel] = []
        for index in 1...10 {
            let owner = UUID().uuidString
            let randomGoal = randomGoal()
            let value = 0..<Int(randomGoal)
            
            let goal = GoalModel(uuid: owner,
                                 name: "Goal \(index)",
                                 type: randomType(),
                                 value: Double(value.randomElement() ?? 0),
                                 goal: randomGoal,
                                 iconGroup: "Weather",
                                 icon: "sun.min",
                                 creationDate: "2023-01-01")
            result.append(goal)
        }

        return result
    }
    
    static func randomGoal() -> Double {
        let goals = 10...100
        return Double(goals.randomElement() ?? 10)
    }
    
    static func randomType() -> GoalType {
        let types = GoalType.allCases
        return types.randomElement() ?? .money
    }
    
    static func randomColor() -> String {
        let color1 = "00ECC1"
        let color2 = "EC0071"
        let color3 = "7289DB"
        let color4 = "F771FA"
        let color5 = "FFB342"
        let colors = [color1, color2, color3, color4, color5]
        
        return colors.randomElement() ?? "1E1E1E"
    }
    
    static func getColors() -> [String] {
        let color1 = "00ECC1"
        let color2 = "EC0071"
        let color3 = "7289DB"
        let color4 = "F771FA"
        let color5 = "FFB342"
        let colors = [color1, color2, color3, color4, color5]
        
        return colors
    }
    
    static func getIcons() -> [(section: String, items: [String])] {
        var icons: [(section: String, items: [String])] = []
        
        icons.append((section: "Gaming", items: ["circle.square", "gamecontroller", "flag.checkered"]))
        icons.append((section: "Object", items: ["pencil.circle", "folder", "camera.filters"]))
        icons.append((section: "Human", items: ["person", "figure.outdoor.cycle", "figure.mind.and.body"]))
        icons.append((section: "Nature", items: ["globe.americas", "globe.europe.africa", "globe.asia.australia", "globe.central.south.asia"]))

        
        return icons
    }
}

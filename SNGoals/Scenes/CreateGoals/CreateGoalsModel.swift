//
//  CreateGoalsModel.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 09/01/23.
//

import Foundation

enum CreateType: Equatable {
    case text(TextStateful)
    case date(DateStateful)
    case segmented(SegmentedStateful)
    case color([ColorStateful])
    case icon([IconsStateful])
    
    static func ==(lhs: CreateType, rhs: CreateType) -> Bool {
        switch (lhs, rhs) {
        case (.text, .text):
            return true
        case (.date, .date):
            return true
        case (.color, .color):
            return true
        case (.icon, .icon):
            return true
        default:
            return false
        }
    }
    
    mutating func change(text value: String, at index: IndexPath) {
        switch self {
        case .text(var text):
            text.text = value
            self = .text(text)
        default:
            return
        }
    }
    
    mutating func change(segmented value: Int, at index: IndexPath) {
        switch self {
        case .segmented(var segmented):
            segmented.selected = value
            segmented.segment = segmented.segmenteds[value]
            self = .segmented(segmented)
        default:
            return
        }
    }
    
    mutating func change(date value: Date, at index: IndexPath) {
        switch self {
        case .date(var date):
            date.date = value
            self = .date(date)
        default:
            return
        }
    }
    
    mutating func change(color value: HEXColor, at index: IndexPath) {
        switch self {
        case .color(var colors):
            for (index, _) in colors.enumerated() {
                colors[index].isSelected = colors[index].color == value
            }
            self = .color(colors)
        default:
            return
        }
    }
    
    mutating func select(iconMenu value: String, at index: IndexPath) {
        switch self {
        case .icon(var icons):
            for (indexSection, _) in icons.enumerated() {
                let isGroupSelected = icons[indexSection].group == value
                icons[indexSection].isSelected = isGroupSelected
                
                for (iconIndex, _) in icons[indexSection].icons.enumerated() {
                    let isSelected = isGroupSelected && iconIndex == 0
                    icons[indexSection].icons[iconIndex].isSelected = isSelected
                }
            }
            self = .icon(icons)
        default:
            return
        }
    }
    
    mutating func change(icon value: String, at index: IndexPath) {
        switch self {
        case .icon(var icons):
            for (index, _) in icons.enumerated() {
                for (iconIndex, _) in icons[index].icons.enumerated() {
                    let isSelected = icons[index].icons[iconIndex].icon == value
                    icons[index].icons[iconIndex].isSelected = isSelected
                }
            }
            self = .icon(icons)
        default:
            return
        }
    }
}

struct TextStateful {
    var text: String?
}

struct SegmentedStateful {
    var segment: GoalType?
    var segmenteds: [String]
    var selected: Int
}

struct DateStateful {
    var date: Date?
}

struct ColorStateful {
    let color: HEXColor
    var isSelected: Bool
}

struct IconsStateful {
    let group: String
    var icons: [IconStateful]
    var isSelected: Bool
}

struct IconStateful {
    let icon: String
    var isSelected: Bool
}

class CreateModel {
    let section: String
    var type: CreateType
    
    init(section: String, type: CreateType) {
        self.section = section
        self.type = type
    }
}

extension Array where Element: CreateModel {
    func selectedColor() -> String? {
        let color = self.first(where: { $0.type == .color([]) })
        switch color?.type {
        case .color(let colors):
            return colors.first(where: { $0.isSelected })?.color
        default:
            return nil
        }
    }
}

extension CreateModel {
    static func create(goals: GoalsModel?) -> [CreateModel] {
        var models: [CreateModel] = []
        models.append(CreateModel(section: "Nome",
                                  type: .text(TextStateful(text: goals?.name))))
        models.append(CreateModel(section: "Data",
                                  type: .date(DateStateful(date: goals?.date))))
        
        let enumeratedColors = MockHelper.getColors().enumerated()
        let selectedColorsIndex = enumeratedColors.first(where: { element in
            return element.element == goals?.color
        }).map { $0.offset } ?? 0
        
        let colors = enumeratedColors.map { ColorStateful(color: $0.element,
                                                          isSelected: goals == nil
                                                          ? ($0.offset == 0)
                                                          : ($0.offset == selectedColorsIndex)) }
        models.append(CreateModel(section: "Cor",
                                  type: .color(colors)))
        
        
        
        var typeIcons: [IconsStateful] = []
        let icons = MockHelper.getIcons()
        
        let enumeratedIconGroup = icons.enumerated()
        let selectedGroupIndex = enumeratedIconGroup.first(where: { element in
            return element.element.section == goals?.iconGroup
        }).map { $0.offset } ?? 0
        icons.enumerated().forEach { (index, icon) in
            let enumeratedIcon = icon.items.enumerated()
            let selectedIconIndex = enumeratedIcon.first(where: { element in
                return element.element == goals?.icon
            }).map { $0.offset } ?? 0
            
            let icons = enumeratedIcon.map { IconStateful(icon: $0.element,
                                                          isSelected: goals == nil
                                                          ? ($0.offset == 0)
                                                          : ($0.offset == selectedIconIndex))}
            typeIcons.append(IconsStateful(group: icon.section,
                                           icons: icons,
                                           isSelected: goals == nil
                                           ? (index == 0)
                                           : (index == selectedGroupIndex)))
        }
        
        
        models.append(CreateModel(section: "Ícone",
                                  type: .icon(typeIcons)))
        return models
    }
    
    static func createGoal() -> [CreateModel] {
        var models: [CreateModel] = []
        models.append(CreateModel(section: "Nome",
                                  type: .text(TextStateful())))
        
        models.append(CreateModel(section: "Tipo",
                                  type: .segmented(SegmentedStateful(segmenteds: ["Número", "Valor"],
                                                                     selected: 0))))
        
        models.append(CreateModel(section: "Valor",
                                  type: .text(TextStateful())))
        
        var typeIcons: [IconsStateful] = []
        let icons = MockHelper.getIcons()
        icons.enumerated().forEach { (index, icon) in
            typeIcons.append(IconsStateful(group: icon.section,
                                           icons: icon.items.enumerated().map { IconStateful(icon: $0.element,
                                                                                             isSelected: $0.offset == 0)},
                                           isSelected: index == 0))
        }
        
        
        models.append(CreateModel(section: "Ícone",
                                  type: .icon(typeIcons)))
        return models
    }
    
    
}

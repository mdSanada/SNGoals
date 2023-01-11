//
//  CreateGoalsModel.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 09/01/23.
//

import Foundation

enum CreateType: Equatable {
    case text([TextStateful])
    case date([DateStateful])
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
        case .text(var texts):
            texts[index.row].text = value
            self = .text(texts)
        default:
            return
        }
    }
    
    mutating func change(date value: Date, at index: IndexPath) {
        switch self {
        case .date(var dates):
            dates[index.row].date = value
            self = .date(dates)
        default:
            return
        }
    }
    
    mutating func change(color value: String, at index: IndexPath) {
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

struct DateStateful {
    var date: Date?
}

struct ColorStateful {
    let color: String
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
    static func create() -> [CreateModel] {
        var models: [CreateModel] = []
        models.append(CreateModel(section: "Nome",
                                  type: .text([TextStateful()])))
        models.append(CreateModel(section: "Data",
                                  type: .date([DateStateful()])))
        
        let colors = MockHelper.getColors().enumerated().map { ColorStateful(color: $0.element,
                                                                             isSelected: $0.offset == 0) }
        models.append(CreateModel(section: "Cor",
                                  type: .color(colors)))
        
        
        
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

//
//  Extension + String.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 11/10/22.
//

import UIKit

extension String {
    subscript(value: Int) -> Character {
        self[index(at: value)]
    }
    
    subscript(value: NSRange) -> Substring {
        self[value.lowerBound..<value.upperBound]
    }
    
    subscript(value: CountableClosedRange<Int>) -> Substring {
        self[index(at: value.lowerBound)...index(at: value.upperBound)]
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        self[index(at: value.lowerBound)..<index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        self[..<index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        self[...index(at: value.upperBound)]
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        self[index(at: value.lowerBound)...]
    }
    
    func index(at offset: Int) -> String.Index {
        index(startIndex, offsetBy: offset)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var digits: String {
        filter { "0"..."9" ~= $0 }
    }
    
    var digitsAndPonctuation: String {
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^[.,0-9]+$]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        return amountWithPrefix
    }

    var number: Double {
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        return (amountWithPrefix as NSString).doubleValue / 100
    }
    
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func percentFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 10000))
        
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func numberFormatting() -> String {
        var number: NSNumber!
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = ","
        formatter.locale = Locale(identifier: "pt_BR")
        
        var amountWithPrefix = self
        let regex = try? NSRegularExpression(pattern: "[^[.,0-9]+$]", options: .caseInsensitive)
        amountWithPrefix = (regex?.stringByReplacingMatches(in: amountWithPrefix as! String,
                                                            options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                            range: NSRange(location: 0, length: self.count),
                                                            withTemplate: "")) as! Self
        
        let double = (amountWithPrefix as! NSString).doubleValue
        number = NSNumber(value: (double))
        guard number != 0 as NSNumber else {
            return ""
        }
        let sNumber = formatter.string(from: number) ?? "0"
        return sNumber
    }
    
    func numberInputFormatting() -> Double {
        var number: NSNumber!
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        formatter.decimalSeparator = ","
        formatter.locale = Locale(identifier: "pt_BR")
        
        var amountWithPrefix = self
        let regex = try? NSRegularExpression(pattern: "[^[.,0-9]+$]", options: .caseInsensitive)
        amountWithPrefix = (regex?.stringByReplacingMatches(in: amountWithPrefix as! String,
                                                            options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                            range: NSRange(location: 0, length: self.count),
                                                            withTemplate: "")) as! Self
        
        let double = (amountWithPrefix as! NSString).doubleValue
        number = NSNumber(value: (double))
        guard number != 0 as NSNumber else {
            return 0.0
        }
        let sNumber = formatter.string(from: number) ?? "0"
        let formattedNumber = formatter.number(from: sNumber) ?? 0
        return Double(truncating: formattedNumber)
    }

    func percentInputFormatting() -> Double {
        var number: NSNumber!
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        formatter.minimumFractionDigits = 10
        formatter.decimalSeparator = ","
        formatter.locale = Locale(identifier: "pt_BR")
        
        var amountWithPrefix = self
        let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = (regex?.stringByReplacingMatches(in: amountWithPrefix as! String,
                                                            options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                            range: NSRange(location: 0, length: self.count),
                                                            withTemplate: "")) as! Self
        
        let double = (amountWithPrefix as! NSString).doubleValue
        number = NSNumber(value: (double / 100))
        guard number != 0 as NSNumber else {
            return 0.0
        }
        let sNumber = formatter.string(from: number) ?? "0"
        let formattedNumber = formatter.number(from: sNumber) ?? 0
        return Double(truncating: formattedNumber)
    }

    func decimalInputFormatting() -> Double {
        var number: NSNumber!
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        formatter.decimalSeparator = ","
        formatter.locale = Locale(identifier: "pt_BR")
        
        var amountWithPrefix = self
        let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = (regex?.stringByReplacingMatches(in: amountWithPrefix as! String,
                                                            options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                            range: NSRange(location: 0, length: self.count),
                                                            withTemplate: "")) as! Self
        
        let double = (amountWithPrefix as! NSString).doubleValue
        number = NSNumber(value: (double / 100))
        guard number != 0 as NSNumber else {
            return 0.0
        }
        let sNumber = formatter.string(from: number) ?? "0"
        let formattedNumber = formatter.number(from: sNumber) ?? 0
        return Double(truncating: formattedNumber)
    }
    
    func onlyNumbers() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

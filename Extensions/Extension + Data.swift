//
//  Data+Extension.swift
//  Sanada
//
//  Created by Matheus D Sanada on 18/03/22.
//

import Foundation

extension Data {
    public func map<D: Decodable>(to type: D.Type) -> D? {
        do {
            let decoder = JSONDecoder()
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "YYYY-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormater)
            let response = try decoder.decode(type.self, from: self)
            
            return response
        } catch let jsonErr {
            Sanada.print(jsonErr)
            return nil
        }
    }
    
    public var dictionary: [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String:Any]
            return json
        } catch let jsonErr {
            Sanada.print(jsonErr)
            return nil
        }
    }
    
    public var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding:.utf8) else { return nil }
        
        return prettyPrintedString
    }
}


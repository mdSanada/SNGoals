//
//  Dictionary+Extension.swift
//  Sanada
//
//  Created by Matheus D Sanada on 18/03/22.
//

import Foundation

extension Dictionary {
    public var data: Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        } catch {
            Sanada.print(error.localizedDescription)
            return nil
        }
    }
}

//
//  Sanada.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 26/09/22.
//

import Foundation

class Sanada {
    public static func print(_ message: Any) {
        #if DEBUG
        let date = Date().string(pattern: .other(pattern: "dd/MM/YYYY - HH:mm:ss"))
        Swift.print("👾 \(date) - \(message)")
        #endif
    }
}

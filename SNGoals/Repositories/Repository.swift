//
//  Repository.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation
import FirebaseFirestore

public class Repository: RepositoryProtocol {
    var colletion: String
    
    init(service: Service) {
        self.colletion = service.collection
    }

    deinit {
        Sanada.print("Deinitializing \(self)")
    }
}

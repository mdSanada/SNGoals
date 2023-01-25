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
    var source: FirestoreSource
    
    init(service: Service, source: FirestoreSource) {
        self.colletion = service.collection
        self.source = source
    }

    deinit {
        Sanada.print("Deinitializing \(self)")
    }
}

//
//  GoalsRepository.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation
import FirebaseFirestore

internal class GoalsRepository {
    private let manager = Repository(service: .goals)

    func getCollection(onLoading: @escaping ((Bool) -> ()),
                       onSuccess: @escaping (([GoalsModel]) -> ()),
                       onError: @escaping ((Error) -> ())) {
        let token = manager.auth.token()
        let collection = manager.dataBase.collection(manager.colletion)
        let filteredCollection = collection.whereField("owner",
                                                       isEqualTo: token)
        
        manager.readCollection(query: filteredCollection,
                       map: GoalsModel.self,
                       onLoading: onLoading,
                       onSuccess: onSuccess,
                       onError: onError)
    }
    
    
    func teste() {
    }
}

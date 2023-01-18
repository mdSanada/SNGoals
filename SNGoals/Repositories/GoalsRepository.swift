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
    private var listeners: [ListenerRegistration] = []
    
    deinit {
        Sanada.print("Deinitializing \(self)")
        listeners.forEach { $0.remove() }
    }
    
    private func collectionPath() -> Query {
        let token = manager.auth.token()
        let collection = manager.dataBase.collection(manager.colletion)
        let filteredCollection = collection.whereField("owner",
                                                       isEqualTo: token)
        return filteredCollection
    }
    
    func getCollection(onLoading: @escaping ((Bool) -> ()),
                       onSuccess: @escaping (([GoalsModel]) -> ()),
                       onError: @escaping ((Error) -> ())) {
        let filteredCollection = collectionPath()
        
        manager.readCollection(query: filteredCollection,
                               map: GoalsModel.self,
                               onLoading: onLoading,
                               onSuccess: { [weak self] goals in
            onSuccess(goals)
        },
                               onError: onError)
    }
    
    func collectionAddSnapshop(onLoading: @escaping ((Bool) -> ()),
                               onSuccess: @escaping (([GoalsModel]) -> ()),
                               onError: @escaping ((Error) -> ())) {
        let filteredCollection = collectionPath()

        let listener = filteredCollection.addSnapshotListener { [weak self] querySnapshot, error in
            guard error == nil else {
                return
            }
            self?.manager.readCollection(query: filteredCollection,
                                        map: GoalsModel.self,
                                        onLoading: onLoading,
                                        onSuccess: onSuccess,
                                        onError: onError)
        }
        listeners.append(listener)
    }
}

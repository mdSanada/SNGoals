//
//  GoalsRepository.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation
import FirebaseFirestore

internal class GoalsRepository {
    private let manager = Repository(service: .goals, source: .default)
    private var listeners: [ListenerRegistration] = [] {
        didSet {
            Sanada.print("Add New Listener: \(listeners)")
        }
    }
    
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
                               onSuccess: onSuccess,
                               onError: onError)
    }
    
    func collectionAddSnapshop(onLoading: @escaping ((Bool) -> ()),
                               onSuccess: @escaping (([GoalsModel]) -> ()),
                               onError: @escaping ((Error) -> ())) {
        let filteredCollection = collectionPath()
        
        let listener = filteredCollection.addSnapshotListener(includeMetadataChanges: true) { [weak self] querySnapshot, error in
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
    
    func save(goals: CreateGoalsRequest,
              onLoading: @escaping ((Bool) -> ()),
              onSuccess: @escaping ((GoalsModel) -> ()),
              onError: @escaping ((Error) -> ())) {
        var _goals = goals
        let collection = manager.dataBase.collection(manager.colletion)
        _goals.owner = manager.auth.token()
        manager.save(document: _goals,
                     in: collection,
                     map: GoalsModel.self,
                     onLoading: onLoading,
                     onSuccess: onSuccess,
                     onError: onError)
    }
    
    func edit(goals: CreateGoalsRequest,
              with uuid: FirestoreId,
              onLoading: @escaping ((Bool) -> ()),
              onSuccess: @escaping ((GoalsModel) -> ()),
              onError: @escaping ((Error) -> ())) {
        var _goals = goals
        let collection = manager.dataBase.collection(manager.colletion)
        _goals.owner = manager.auth.token()
        manager.update(document: _goals,
                       with: uuid,
                       in: collection,
                       map: GoalsModel.self,
                       onLoading: onLoading,
                       onSuccess: onSuccess,
                       onError: onError)
    }
    
    func delete(with uuid: FirestoreId,
                onLoading: @escaping ((Bool) -> ()),
                onSuccess: @escaping (() -> ()),
                onError: @escaping ((Error) -> ())) {
        let collection = manager.dataBase.collection(manager.colletion)
        manager.delete(delete: uuid,
                       in: collection,
                       onLoading: onLoading,
                       onSuccess: onSuccess,
                       onError: onError)
    }
}

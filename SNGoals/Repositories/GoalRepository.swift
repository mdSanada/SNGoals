//
//  GoalRepository.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation
import FirebaseFirestore

internal class GoalRepository {
    private let manager = Repository(service: .goals, source: .default)
    private let goal = "GOAL"
    private var listeners: [ListenerRegistration] = [] {
        didSet {
            Sanada.print("Add New Listener: \(listeners)")
        }
    }
    
    deinit {
        Sanada.print("Deinitializing \(self)")
        listeners.forEach { $0.remove() }
    }
    
    private func collectionPath(at uuid: FirestoreId) -> CollectionReference {
        let token = manager.auth.token()
        let collection = manager.dataBase.collection(manager.colletion).document(uuid).collection(goal)
        return collection
    }
    
    func getCollection(at uuid: FirestoreId,
                       onLoading: @escaping ((Bool) -> ()),
                       onSuccess: @escaping (([GoalModel]) -> ()),
                       onError: @escaping ((Error) -> ())) {
        let filteredCollection = collectionPath(at: uuid)
        
        manager.readCollection(query: filteredCollection,
                               map: GoalModel.self,
                               onLoading: onLoading,
                               onSuccess: onSuccess,
                               onError: onError)
    }
    
    func collectionAddSnapshop(at uuid: FirestoreId,
                               onLoading: @escaping ((Bool) -> ()),
                               onSuccess: @escaping (([GoalModel]) -> ()),
                               onError: @escaping ((Error) -> ())) {
        let filteredCollection = collectionPath(at: uuid)
        
        let listener = filteredCollection.addSnapshotListener(includeMetadataChanges: true) { [weak self] querySnapshot, error in
            guard error == nil else {
                return
            }
            self?.manager.readCollection(query: filteredCollection,
                                         map: GoalModel.self,
                                         onLoading: onLoading,
                                         onSuccess: onSuccess,
                                         onError: onError)
        }
        listeners.append(listener)
    }
    
    func save(at uuid: FirestoreId,
              goal: CreateGoalRequest,
              onLoading: @escaping ((Bool) -> ()),
              onSuccess: @escaping ((GoalModel) -> ()),
              onError: @escaping ((Error) -> ())) {
        let collection = collectionPath(at: uuid)
        manager.save(document: goal,
                     in: collection,
                     map: GoalModel.self,
                     onLoading: onLoading,
                     onSuccess: onSuccess,
                     onError: onError)
    }
    
    func edit(at uuid: FirestoreId,
              goal: CreateGoalRequest,
              with editedUUID: FirestoreId,
              onLoading: @escaping ((Bool) -> ()),
              onSuccess: @escaping ((GoalModel) -> ()),
              onError: @escaping ((Error) -> ())) {
        let collection = collectionPath(at: uuid)
        manager.update(document: goal,
                       with: uuid,
                       in: collection,
                       map: GoalModel.self,
                       onLoading: onLoading,
                       onSuccess: onSuccess,
                       onError: onError)
    }
    
    func editValue(at collectionUUID: FirestoreId,
                   value: Double,
                   with editedUUID: FirestoreId,
                   onLoading: @escaping ((Bool) -> ()),
                   onSuccess: @escaping ((GoalModel) -> ()),
                   onError: @escaping ((Error) -> ())) {
        let collection = collectionPath(at: collectionUUID)
        manager.edit(update: ["value": value],
                     with: editedUUID,
                     in: collection,
                     onLoading: onLoading,
                     onSuccess: onSuccess,
                     onError: onError)
    }
    
    func deleteGoal(at collectionUUID: FirestoreId,
                    with editedUUID: FirestoreId,
                    onLoading: @escaping ((Bool) -> ()),
                    onSuccess: @escaping (() -> ()),
                    onError: @escaping ((Error) -> ())) {
         let collection = collectionPath(at: collectionUUID)
         manager.delete(delete: editedUUID,
                        in: collection,
                        onLoading: onLoading,
                        onSuccess: onSuccess,
                        onError: onError)
     }
}

//
//  RepositoryProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation
import FirebaseFirestore

private class SNDataBase {
    static let shared = SNDataBase()
    let firestore: Firestore
    
    init() {
        let settings = FirestoreSettings()
        let db = Firestore.firestore()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
//        db.disableNetwork()
        firestore = db
    }
}

internal protocol RepositoryProtocol {
    var colletion: String { get }
    var dataBase: Firestore { get }
    var source: FirestoreSource { get }
    
    /// Makes a `GET` Query request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func readCollection<T: Decodable>(query: Query,
                                      map: T.Type,
                                      onLoading: @escaping ((Bool) -> ()),
                                      onSuccess: @escaping (([T]) -> ()),
                                      onError: @escaping ((Error) -> ()))
    
    /// Makes a `GET` Collection request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func readCollection<T: Decodable>(collection: CollectionReference,
                                      map: T.Type,
                                      onLoading: @escaping ((Bool) -> ()),
                                      onSuccess: @escaping (([T]) -> ()),
                                      onError: @escaping ((Error) -> ()))
    
    /// Makes a `GET` request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func read<T: Codable>(collection: CollectionReference,
                          with uuid: FirestoreId,
                          map: T.Type,
                          onLoading: @escaping ((Bool) -> ()),
                          onSuccess: @escaping ((T) -> ()),
                          onError: @escaping ((Error) -> ()))
    
    /// Makes a `POST` request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func save<T: Codable, M: Codable>(document: T,
                                      in collection: CollectionReference,
                                      map to: M.Type,
                                      onLoading: @escaping ((Bool) -> ()),
                                      onSuccess: @escaping ((M) -> ()),
                                      onError: @escaping ((Error) -> ()))
    
    /// Makes a `PUT` request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func update<T: Codable, M: Codable>(document: T,
                                        with uuid: FirestoreId,
                                        in collection: CollectionReference,
                                        map to: M.Type,
                                        onLoading: @escaping ((Bool) -> ()),
                                        onSuccess: @escaping ((M) -> ()),
                                        onError: @escaping ((Error) -> ()))
    
    /// Makes a `PUT` request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func edit<M: Codable>(update data: [AnyHashable : Any],
                          with uuid: FirestoreId,
                          in collection: CollectionReference,
                          onLoading: @escaping ((Bool) -> ()),
                          onSuccess: @escaping ((M) -> ()),
                          onError: @escaping ((Error) -> ()))
    
    /// Makes a `DELETE` request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func delete(delete uuid: FirestoreId,
                in collection: CollectionReference,
                onLoading: @escaping ((Bool) -> ()),
                onSuccess: @escaping (() -> ()),
                onError: @escaping ((Error) -> ()))
}

extension RepositoryProtocol {
    var auth: AuthRepository {
        return AuthRepository()
    }
    
    var dataBase: Firestore {
        return SNDataBase.shared.firestore
    }
    
    func readCollection<T>(query: Query,
                           map: T.Type,
                           onLoading: @escaping ((Bool) -> ()),
                           onSuccess: @escaping (([T]) -> ()),
                           onError: @escaping ((Error) -> ())) where T : Decodable {
        onLoading(true)
        query.getDocuments(source: source) { query, error in
            if let query = query {
                let data = query.documents.compactMap { response -> T? in
                    var dict = response.data()
                    dict["uuid"] = response.documentID
                    
                    guard let result = dict.data?.map(to: T.self) else { return nil }
                    return result
                }.compactMap { $0 }
                onLoading(false)
                onSuccess(data)
            } else {
                onLoading(false)
                onError(NSError(domain: "", code: 1, userInfo: [:]) as! Error)
            }
        }
    }
    
    
    func readCollection<T>(collection: CollectionReference,
                           map: T.Type,
                           onLoading: @escaping ((Bool) -> ()),
                           onSuccess: @escaping (([T]) -> ()),
                           onError: @escaping ((Error) -> ())) where T : Decodable {
        onLoading(true)
        collection.getDocuments(source: source) { query, error in
            if let query = query {
                let data = query.documents.compactMap { response -> T? in
                    var dict = response.data()
                    dict["uuid"] = response.documentID
                    
                    guard let result = dict.data?.map(to: T.self) else { return nil }
                    return result
                }.compactMap { $0 }
                onLoading(false)
                onSuccess(data)
            } else {
                onLoading(false)
                onError(NSError.defaultError())
            }
        }
    }
    
    func read<T: Codable>(collection: CollectionReference,
                          with uuid: FirestoreId,
                          map: T.Type,
                          onLoading: @escaping ((Bool) -> ()),
                          onSuccess: @escaping ((T) -> ()),
                          onError: @escaping ((Error) -> ())) where T : Codable {
        collection.document(uuid).getDocument(source: source) { document, error in
            if let document = document {
                var dict = document.data()
                dict?["uuid"] = document.documentID
                if let response = dict?.data?.map(to: T.self) {
                    onSuccess(response)
                } else {
                    onError(error ?? NSError.defaultError())
                }
            } else {
                onError(error ?? NSError.defaultError())
            }
        }
    }
    
    func save<T: Codable, M: Codable>(document: T,
                                      in collection: CollectionReference,
                                      map to: M.Type,
                                      onLoading: @escaping ((Bool) -> ()),
                                      onSuccess: @escaping ((M) -> ()),
                                      onError: @escaping ((Error) -> ())) where T : Decodable {
        onLoading(true)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(document), var dict = data.dictionary {
            var listener: ListenerRegistration? = nil
            dict["updated-date"] = Date().string(pattern: .expanded_api)
            listener = collection
                .addDocument(data: dict)
                .addSnapshotListener(includeMetadataChanges: true) { (_document, error) in
                    listener?.remove()
                    onLoading(false)
                    if let _document = _document {
                        var dict = _document.data()
                        dict?["uuid"] = _document.documentID
                        if let response = dict?.data?.map(to: M.self) {
                            onSuccess(response)
                        } else {
                            onError(error ?? NSError.defaultError())
                        }
                    } else {
                        onError(error ?? NSError.defaultError())
                    }
                }
        } else {
            onLoading(false)
            onError(NSError.defaultError())
        }
    }
    
    func update<T: Codable, M: Codable>(document: T,
                                        with uuid: FirestoreId,
                                        in collection: CollectionReference,
                                        map to: M.Type,
                                        onLoading: @escaping ((Bool) -> ()),
                                        onSuccess: @escaping ((M) -> ()),
                                        onError: @escaping ((Error) -> ())) where T : Decodable {
        onLoading(true)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(document), var dict = data.dictionary {
            dict["updated-date"] = Date().string(pattern: .expanded_api)
            collection
                .document(uuid)
                .setData(dict, merge: true)
            
            var listener: ListenerRegistration? = nil
            listener = collection.document(uuid)
                .addSnapshotListener(includeMetadataChanges: true) { (_document, error) in
                    listener?.remove()
                    onLoading(false)
                    if let _document = _document {
                        var dict = _document.data()
                        dict?["uuid"] = uuid
                        if let response = dict?.data?.map(to: M.self) {
                            onSuccess(response)
                        } else {
                            onError(error ?? NSError.defaultError())
                        }
                    } else {
                        onError(error ?? NSError.defaultError())
                    }
                }
        } else {
            onLoading(false)
            onError(NSError.defaultError())
        }
    }
    
    func edit<M: Codable>(update data: [AnyHashable : Any],
                          with uuid: FirestoreId,
                          in collection: CollectionReference,
                          onLoading: @escaping ((Bool) -> ()),
                          onSuccess: @escaping ((M) -> ()),
                          onError: @escaping ((Error) -> ())) where M : Codable {
        onLoading(true)
        var dict = data
        dict["updated-date"] = Date().string(pattern: .expanded_api)
        collection
            .document(uuid)
            .updateData(dict)
        
        var listener: ListenerRegistration? = nil
        listener = collection.document(uuid)
            .addSnapshotListener(includeMetadataChanges: true) { (_document, error) in
                listener?.remove()
                onLoading(false)
                if let _document = _document {
                    var dict = _document.data()
                    dict?["uuid"] = uuid
                    if let response = dict?.data?.map(to: M.self) {
                        onSuccess(response)
                    } else {
                        onError(error ?? NSError.defaultError())
                    }
                } else {
                    onError(error ?? NSError.defaultError())
                }
            }
    }
    
    func delete(delete uuid: FirestoreId,
                in collection: CollectionReference,
                onLoading: @escaping ((Bool) -> ()),
                onSuccess: @escaping (() -> ()),
                onError: @escaping ((Error) -> ())) {
        onLoading(true)
        collection.document(uuid).delete() { error in
            onLoading(false)
            if let error = error {
                onError(error)
                return
            }
            onSuccess()
        }
    }
}

extension NSError {
    static func defaultError() -> Error {
        return NSError(domain: "", code: 1, userInfo: [:]) as Error
    }
}

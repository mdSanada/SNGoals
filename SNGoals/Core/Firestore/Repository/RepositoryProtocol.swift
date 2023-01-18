//
//  RepositoryProtocol.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation
import FirebaseFirestore

internal protocol RepositoryProtocol {
    var colletion: String { get }
    var dataBase: Firestore { get }
    
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
    func read<T: Decodable>(document: DocumentReference,
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
    func save<T: Decodable>(collection: CollectionReference,
                            onLoading: @escaping ((Bool) -> ()),
                            onSuccess: @escaping ((T) -> ()),
                            onError: @escaping ((Error) -> ()))
    
    /// Makes a `PUT` request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func update<T: Decodable>(document: DocumentReference,
                              onLoading: @escaping ((Bool) -> ()),
                              onSuccess: @escaping ((T) -> ()),
                              onError: @escaping ((Error) -> ()))
    
    /// Makes a `DELETE` request.
    ///
    /// - parameter onLoading: Returns the request state `Bool`.
    /// - parameter onSuccess: Returns the `object` mapped.
    /// - parameter onError: Returns an `Error` on request.
    /// - parameter onMapError: Returns an `Data`, when tryied to map an failured.
    ///
    /// - Returns: `Void`.
    func delete<T: Decodable>(document: DocumentReference,
                              onLoading: @escaping ((Bool) -> ()),
                              onSuccess: @escaping ((T) -> ()),
                              onError: @escaping ((Error) -> ()))
}

extension RepositoryProtocol {
    var auth: AuthRepository {
        return AuthRepository()
    }

    var dataBase: Firestore {
        return Firestore.firestore()
    }
    
    func readCollection<T>(query: Query,
                           map: T.Type,
                           onLoading: @escaping ((Bool) -> ()),
                           onSuccess: @escaping (([T]) -> ()),
                           onError: @escaping ((Error) -> ())) where T : Decodable {
        onLoading(true)
        query.getDocuments(source: .default) { query, error in
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
        collection.getDocuments(source: .default) { query, error in
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
    
    func read<T>(document: DocumentReference, map: T.Type, onLoading: @escaping ((Bool) -> ()), onSuccess: @escaping ((T) -> ()), onError: @escaping ((Error) -> ())) where T : Decodable {
        
    }
    
    func save<T>(collection: CollectionReference, onLoading: @escaping ((Bool) -> ()), onSuccess: @escaping ((T) -> ()), onError: @escaping ((Error) -> ())) where T : Decodable {
        
    }
    
    func update<T>(document: DocumentReference, onLoading: @escaping ((Bool) -> ()), onSuccess: @escaping ((T) -> ()), onError: @escaping ((Error) -> ())) where T : Decodable {
        
    }
    
    func delete<T>(document: DocumentReference, onLoading: @escaping ((Bool) -> ()), onSuccess: @escaping ((T) -> ()), onError: @escaping ((Error) -> ())) where T : Decodable {
        
    }
}

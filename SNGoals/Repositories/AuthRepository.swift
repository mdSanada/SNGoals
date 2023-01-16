//
//  LoginRepository.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 13/01/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth

class AuthRepository {
    public func authenticate(with email: String,
                             and password: String,
                             completion: @escaping ((Bool) -> ())) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard error == nil, let user = authResult else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func token() -> String? {
        let auth = Auth.auth().currentUser?.uid
        return auth
    }
    
    public func isLogged() -> Bool {
        return Auth.auth().currentUser != nil
    }
}

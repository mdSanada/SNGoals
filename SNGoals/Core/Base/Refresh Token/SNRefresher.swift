//
//  ACRefresher.swift
//  AppCare
//
//  Created by Matheus D Sanada on 21/03/22.
//

import Foundation

internal class SNRefresher {
    internal var manager: SNNetworkManager<SNRefreshTokenService>? = nil
    var session: URLSession? = URLSession.init(configuration: URLSessionConfiguration.default)
    
    internal init () {
        manager = SNNetworkManager<SNRefreshTokenService>()
    }
    
    deinit {
        manager = nil
    }

    internal func refresh(onSuccess: @escaping ((SNRefreshTokenModel) -> Void),
                        onError: @escaping ((Error) -> Void)) {
        // TODO: - Change this to keychain
        guard let session = session else {
            onError(NSError(domain: "", code: -1, userInfo: [:]))
            return
        }
        // TODO: - Add Refresh token to request
        manager?.request(.refresh("Add Token here"),
                         map: SNRefreshTokenModel.self,
                         session: session,
                         onLoading: { _ in },
                         onSuccess: { token in
            // TODO: - Save new token
            onSuccess(token)
            Sanada.print("Refresh Token: Success")
        },
                         onError: { error in
            Sanada.print("Refresh Token: Error")
            onError(error)
        },
                         onMapError: { _ in
            Sanada.print("Refresh Token: Map Error")
            onError(NSError(domain: "", code: -1, userInfo: [:]))
        }, isRefreshToken: true)
    }
}

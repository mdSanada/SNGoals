//
//  ACRefreshTokenService.swift
//  AppCare
//
//  Created by Matheus D Sanada on 21/03/22.
//

import Foundation

internal enum SNRefreshTokenService {
    case refresh(_ token: String)
}

extension SNRefreshTokenService: SNNetworkTask {
    var baseURL: SNNetworkBaseURL {
        return .normal
    }

    var path: String {
        switch self {
        case .refresh:
            return "api/token/refresh"
        }
    }
    
    var method: SNNetworkMethod {
        switch self {
        case .refresh:
            return .post
        }
    }
    
    var params: [String : Any] {
        var dict: [String : Any] = [:]
        switch self {
        case .refresh(let token):
            dict["refresh_token"] = token
            dict["grant_type"] = "refresh_token"
            return dict
        }
    }
    
    var encoding: EncodingMethod {
        switch self {
        case .refresh:
            return .body
        }
    }

    var headers: [String : String]? {
        return ["refresh_token": "1"]
    }
}

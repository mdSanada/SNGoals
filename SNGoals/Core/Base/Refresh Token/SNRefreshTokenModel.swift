//
//  ACRefreshTokenModel.swift
//  AppCare
//
//  Created by Matheus D Sanada on 21/03/22.
//

import Foundation

// MARK: - RefreshTokenModel
internal struct SNRefreshTokenModel: Codable {
    let username: String
    let accessToken, refreshToken, tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case username
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

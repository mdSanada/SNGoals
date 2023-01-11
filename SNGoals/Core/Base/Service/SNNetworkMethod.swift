//
//  ACNetworkMethod.swift
//  Sanada
//
//  Created by Matheus D Sanada on 18/03/22.
//

import Foundation

/// `HTTP` Request method.
public struct SNNetworkMethod: RawRepresentable, Equatable, Hashable {
    /// `DELETE` method.
    public static let delete = SNNetworkMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = SNNetworkMethod(rawValue: "GET")
    /// `PATCH` method.
    public static let patch = SNNetworkMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = SNNetworkMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = SNNetworkMethod(rawValue: "PUT")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension SNNetworkMethod {
    /// `HTTP Method`
    var httpMethod: String {
        self.rawValue
    }
}

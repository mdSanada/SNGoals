//
//  ACNetworkTask.swift
//  Sanada
//
//  Created by Matheus D Sanada on 18/03/22.
//

import Foundation

/// Creates an requestable enum.
public protocol SNNetworkTask {
    /// The target's base `URL`.
    var baseURL: SNNetworkBaseURL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: SNNetworkMethod { get }

    /// The type of HTTP task to be performed.
    var params: [String: Any] { get }
    
    /// The type of HTTP task to be performed.
    var encoding: EncodingMethod { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}

public enum EncodingMethod {
    case queryString
    case body
}

public enum SNNetworkBaseURL {
    case normal
    case url(URL)
}

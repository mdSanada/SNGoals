//
//  ACRequestable.swift
//  Sanada
//
//  Created by Matheus D Sanada on 18/03/22.
//

import Foundation

internal protocol SNRequestable {
    func createRequest(task: SNNetworkTask) -> URLRequest
    func setHTTPMethod(to request: inout URLRequest, task: SNNetworkTask)
    func setHeaders(to request: inout URLRequest, task: SNNetworkTask)
    func setParameters(to request: inout URLRequest, task: SNNetworkTask)
    func createTask<T: Decodable>(_ request: URLRequest,
                                  in session: URLSession,
                                  onLoading: @escaping ((Bool) -> ()),
                                  onSuccess: @escaping ((T) -> ()),
                                  onError: @escaping ((NSError) -> ()),
                                  onMapError: ((Data) -> ())?) -> URLSessionDataTask
    func request(_ task: URLSessionDataTask)
}

extension SNRequestable {
    internal func createRequest(task: SNNetworkTask) -> URLRequest {
        var baseUrl: URL?
        switch task.baseURL {
        case .normal:
            // TODO: - Add API URL
            baseUrl = URL(string: "")
        case .url(let url):
            baseUrl = url
        }
        let path = task.path
        // MARK: - Base URL with Path
        baseUrl = baseUrl?.appendingPathComponent(path)
        return URLRequest(url: baseUrl!,
                          cachePolicy: .reloadIgnoringCacheData,
                          timeoutInterval: 20)
    }
    
    internal func setHTTPMethod(to request: inout URLRequest, task: SNNetworkTask) {
        request.httpMethod = task.method.httpMethod
    }
    
    internal func setParameters(to request: inout URLRequest, task: SNNetworkTask) {
        switch task.encoding {
        case .queryString:
            appendQueryString(to: &request, task: task)
        case .body:
            appendBody(to: &request, task: task)
        }
    }
    
    private func appendBody(to request: inout URLRequest, task: SNNetworkTask) {
        guard !task.params.isEmpty else {
            return
        }
        request.httpBody = task.params.data
    }
    
    private func appendQueryString(to request: inout URLRequest, task: SNNetworkTask) {
        var url: URL? {
            guard let scheme = request.url?.scheme,
                  let host = request.url?.host,
                  let path = request.url?.path,
                  let url = request.url else {
                      return request.url
                  }
            guard !task.params.isEmpty else {
                return url
            }
            let queryItems = task.params.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
            components.queryItems = queryItems
            return components.url
        }
        if let url = url {
            request = URLRequest(url: url,
                                 cachePolicy: request.cachePolicy,
                                 timeoutInterval: request.timeoutInterval)
        }
    }
    
    internal func setHeaders(to request: inout URLRequest, task: SNNetworkTask) {
        if let headers = task.headers {
            request.allHTTPHeaderFields = headers
            
            if headers["Content-Type"] == nil,
               task.encoding == .body {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            if headers["Authorization"] == nil,
                headers["refresh_token"] == nil {
                // TODO: -  Add Bearer Token
                let token = "Get Token"
                Sanada.print("Request: Setting Token")
                request.addValue(token, forHTTPHeaderField: "Authorization")
            }
        }
    }
    
    internal func createTask<T: Decodable>(_ request: URLRequest,
                                           in session: URLSession,
                                           onLoading: @escaping ((Bool) -> ()),
                                           onSuccess: @escaping ((T) -> ()),
                                           onError: @escaping ((NSError) -> ()),
                                           onMapError: ((Data) -> ())?) -> URLSessionDataTask {
        session.dataTask(with: request) { (data, response, error) in
            if !(getStatusCode(from: response) == 401) {
                Sanada.print("Request: Loading(false)")
                onLoading(false)
            }
            // Check for Error
            if let error = error {
                onError(NSError(domain: request.url?.description ?? "",
                                code: -1,
                                userInfo: [:]))
                return
            }

            // Convert HTTP Response Data
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        guard let object = data.map(to: T.self) else {
                            Sanada.print("Request: Map Error")
                            if let onMapError = onMapError {
                                onMapError(data)
                            } else {
                                onError(NSError(domain: request.url?.description ?? "",
                                                code: httpResponse.statusCode,
                                                userInfo: [:]))
                            }
                            return
                        }
                        Sanada.print("Request: Success")
                        onSuccess(object)
                    } else if httpResponse.statusCode == 401 {
                        refreshToken(request,
                                     in: session,
                                     onLoading: onLoading,
                                     onSuccess: onSuccess,
                                     onError: onError,
                                     onMapError: onMapError)
                    } else {
                        Sanada.print("Request: Error")
                        let code = getStatusCode(from: response)
                        onError(NSError(domain: request.description,
                                        code: code,
                                        userInfo: data.dictionary))
                    }
                }
            } else {
                Sanada.print("Request: Data Error")
                let code = getStatusCode(from: response)
                onError(NSError(domain: request.description,
                                code: code,
                                userInfo: nil))
            }
        }
    }
    
    internal func updateToken(to request: inout URLRequest) {
        // TODO: - Get Bearer Token
        let token = "Get Token"
        Sanada.print("Request: Update Token")
        request.setValue(token, forHTTPHeaderField: "Authorization")
    }
    
    internal func refreshToken<T: Decodable>(_ request: URLRequest,
                                             in session: URLSession,
                                             onLoading: @escaping ((Bool) -> ()),
                                             onSuccess: @escaping ((T) -> ()),
                                             onError: @escaping ((NSError) -> ()),
                                             onMapError: ((Data) -> ())?) {
        Sanada.print("Refresh Token")
        session.invalidateAndCancel()
        let manager = SNRefresher()
        manager.refresh { newToken in
            var newRequest = request
            updateToken(to: &newRequest)
            let task = createTask(newRequest,
                                  in: session,
                                  onLoading: onLoading,
                                  onSuccess: onSuccess,
                                  onError: onError,
                                  onMapError: onMapError)
            task.resume()
        } onError: { error in
            onError(NSError(domain: request.url?.description ?? "",
                            code: -1,
                            userInfo: [:]))
        }
    }
    
    internal func getStatusCode(from urlResponse: URLResponse?) -> Int {
        if let httpResponse = urlResponse as? HTTPURLResponse {
            return httpResponse.statusCode
        } else {
            return -1
        }
    }

    internal func request(_ task: URLSessionDataTask) {
        Sanada.print("Request: \(task.currentRequest?.url?.description ?? "")")
        task.resume()
    }
}

//
//  HTTPRequest.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

typealias ArrayParameters = [Any]
typealias Parameters = [String: Any]
typealias HTTPHeaders = [String: String]

class HTTPRequest {

    enum Encoding {
        case queryString
        case body
    }

    var url: URL?
    var method: HTTPMethod
    var parameters: Parameters = [:]
    var arrayParameters: ArrayParameters = []
    var headers: HTTPHeaders?
    var encoding: Encoding

    init(url: String, method: HTTPMethod, parameters: Parameters?,
         headers: HTTPHeaders?, encoding: Encoding = .body) {
        self.url = URL(string: url)
        self.method = method
        self.headers = headers
        self.encoding = encoding
        if let parameters = parameters {
            self.parameters = parameters
        }
    }

    init(url: String, method: HTTPMethod, arrayParameters: ArrayParameters?,
         headers: HTTPHeaders?, encoding: Encoding = .body) {
        self.url = URL(string: url)
        self.method = method
        self.headers = headers
        self.encoding = encoding
        if let arrayParameters = arrayParameters {
            self.arrayParameters = arrayParameters
        }
    }
}

//
//  NetworkError.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import Foundation

enum NetworkError: Error, Equatable {
    case nilError
    case unknown
    case decodeError
    case unauthorized
    case nointernet
    case timeout
    case notFound
    case serverError
    case badRequest(response: Data?)
    case forbidden(response: Data?)
    case conflict(response: Data?)
    case gone(response: Data?)
    case customError(title: String, details: String)
    case other

    var description: String {
        switch self {
        case .unknown:
            return "Unknown Error"
        case .nilError:
            return "Nil Error"
        case .decodeError:
            return "Formatting Error"
        case .unauthorized:
            return "Unauthorized Error"
        case .nointernet:
            return "No Internet Error"
        case .serverError:
            return "Server Error"
        case .timeout:
            return "Timeout Error"
        case .notFound:
            return "Not Found Error"
        case .badRequest:
            return "Bad Request Error"
        case .forbidden:
            return "Forbidden Error"
        case .conflict:
            return "Conflict Error"
        case .gone:
            return "Gone Error"
        case .other:
            return "API Error"
        default:
            return "Unhandled Error Description"
        }
    }
}

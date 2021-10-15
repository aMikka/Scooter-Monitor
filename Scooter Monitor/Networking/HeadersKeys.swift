//
//  HeadersKeys.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import Foundation

struct HeadersKeys {

    struct ContentType {
        static let name = "Content-Type"
        static let value = "application/json"
    }

    struct SecretKey {
        static let name = "secret-key"
    }

    // NOTE: Simple method to protect APIKey against string dumping.
    // On production app, a more sophisticated method is required.
    static func a$2b$10$VE0tRqquld4OBl7LDeo9vpointafsyRXFlXcQzmj1KpEB6K1wG2okzQcK() -> String {
        var key = "\(#function)"
        key.removeFirst()
        key.removeLast(2)

        return key.replacingOccurrences(of: "point", with: ".")
    }

    static func APIKey () -> String {
        return a$2b$10$VE0tRqquld4OBl7LDeo9vpointafsyRXFlXcQzmj1KpEB6K1wG2okzQcK()
    }

}

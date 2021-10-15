//
//  StatusCodes.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import Foundation

struct SuccessCodes {
    static let ok = 200
}

// Note: for the sake of simplicity, all other status codes are mapped to '.other' error
struct ErrorCodes {
    static let notConnectedToInternet = -1009
    static let timeout = -1001
}

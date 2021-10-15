//
//  Vehicle.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import MapKit
import UIKit

class Vehicle: NSObject, Decodable, MKAnnotation {

    enum VehicleState: String, Decodable {
        case active = "ACTIVE"
        case lowBattery = "LOW_BATTERY"
        case maintenance = "MAINTENANCE"
        case lastSearch = "LAST_SEARCH"
        case damaged = "DAMAGED"
        case outOfOrder = "OUT_OF_ORDER"
        case lost = "LOST"
        case gpsIssue = "GPS_ISSUE"
        case missing = "MISSING"
        case unknown

        public init(from decoder: Decoder) throws {
            self = try VehicleState(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
        }
    }

    enum MonitoringStatus {
        case normal
        case warning
        case error
        case unknown
    }

    var battery: Int?
    var state: VehicleState?

    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}

extension Vehicle {
    func displayStatus() -> MonitoringStatus {
        switch state {
        case .active, .lastSearch:
            return .normal
        case .gpsIssue, .lowBattery, .maintenance:
            return .warning
        case .lost, .damaged, .outOfOrder, .missing:
            return .error
        default:
            return .unknown
        }
    }
}

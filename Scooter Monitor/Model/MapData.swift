//
//  MapData.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import MapKit
import CoreLocation

struct MapResponse: Decodable {
    let data: MapData
}

struct MapData: Decodable {
    let current: [Vehicle]

    let centerLatitude: CLLocationDegrees?
    let centerLongitude: CLLocationDegrees?
    let latitudeDelta: CLLocationDegrees?
    let longitudeDelta: CLLocationDegrees?

//    var region: MKCoordinateRegion {
//        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
//        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
//        return MKCoordinateRegion(center: center, span: span)
//    }
}

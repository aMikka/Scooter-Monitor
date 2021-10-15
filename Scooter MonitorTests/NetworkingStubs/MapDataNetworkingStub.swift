//
//  MapDataNetworkingStub.swift
//  Scooter MonitorTests
//
//  Created by Miklos Aron on 2021. 10. 14.
//

@testable import Scooter_Monitor

import Foundation
import MapKit

enum MapDataNetworkingStubType {
    case success
    case timeout
    case noInternet
    case unknownError
}

class MapDataNetworkingStub: MapDataNetworking {

    func fetchMapData(completion: @escaping (Result<MapResponse, NetworkError>) -> Void) {
        if let mockData = getMockData() {
            completion(.success(mockData))
        }
    }
}

extension MapDataNetworkingStub {
    private func getMockData() -> MapResponse? {
        if let url = Bundle.main.url(forResource: "mapMockData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MapResponse.self, from: data)

                return(jsonData)
            } catch {
                print("Error loading mock data:\(error)")
            }
        }
        return nil
    }
}

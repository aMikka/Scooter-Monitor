//
//  MapViewModelTests.swift
//  Scooter MonitorTests
//
//  Created by Miklos Aron on 2021. 10. 14.
//

@testable import Scooter_Monitor

import Foundation
import MapKit
import Quick
import Nimble

class MapViewModelSpec: QuickSpec {

    var viewModel: MapViewModelImpl?
    private var isSuccess = false

    override func spec() {
        describe("MapViewModel funcionality") {

            beforeEach { _ in
                self.viewModel = MapViewModelImpl(networking: MapDataNetworkingStub())
                self.viewModel?.delegate = self
            }

            it("Should fetch map data") {
                self.viewModel?.fetchData()
                expect(self.viewModel?.annotations?.count).to(equal(151))
            }

        }
    }

}

extension MapViewModelSpec: MapViewModelDelegate {

    func dataFetched(annotations: [MKAnnotation]) {
        // Intentionally empty
    }

    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        // Intentionally empty
    }
}

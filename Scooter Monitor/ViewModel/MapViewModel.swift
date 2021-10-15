//
//  MapViewModel.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 12.
//

import Foundation
import MapKit

protocol MapViewModelDelegate: AnyObject {
    func dataFetched(annotations: [MKAnnotation])
    func showAlert(title: String, message: String, actions: [UIAlertAction])
}

protocol MapViewModel: AnyObject {
    var delegate: MapViewModelDelegate? { get set }
    var annotations: [MKAnnotation]? { get }

    func fetchData()
    func findNearestPin(from: [MKAnnotation], currentLocation: CLLocation) -> MKAnnotation?
}

class MapViewModelImpl: MapViewModel {

    weak var delegate: MapViewModelDelegate?

    private let networking: MapDataNetworking
    internal var annotations: [MKAnnotation]?

    init(networking: MapDataNetworking) {
        self.networking = networking
    }

    func fetchData() {
        networking.fetchMapData { [weak self ] (result) in
            switch result {
            case .success(let mapResponse):
                let annotations = mapResponse.data.current
                self?.annotations = annotations
                self?.delegate?.dataFetched(annotations: annotations)
            case .failure(let err):
                    if err == .nointernet {
                        self?.showInternetError()
                    } else {
                        self?.showAPIError()
                    }
            }
        }
    }

    func findNearestPin(from: [MKAnnotation], currentLocation: CLLocation) -> MKAnnotation? {
        let nearestPin: MKAnnotation? = from.reduce((CLLocationDistanceMax, nil)) { (nearest, pin) in
            let coord = pin.coordinate
            let loc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            let distance = currentLocation.distance(from: loc)
            return distance < nearest.0 ? (distance, pin) : nearest
        }.1

        if nearestPin != nil {
            return nearestPin
        }

        return nil
    }
}

// MARK: - Private helpers

extension MapViewModelImpl {
    private func showInternetError() {

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }

        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.fetchData()
        }

        delegate?.showAlert(title: "Connection Error",
                            message: "Internet is not available. Check your connection and try again.",
                            actions: [okAction, retryAction]
        )
    }

    private func showAPIError() {

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }

        let retryAction = UIAlertAction(title: "Try again", style: .default) { _ in
            self.fetchData()
        }

        delegate?.showAlert(title: "Error",
                            message: "Error fetching scooter data. Try again later.",
                            actions: [okAction, retryAction]
        )
    }
}

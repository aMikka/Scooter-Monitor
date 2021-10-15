//
//  MapViewController.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 10.
//

import MapKit

class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var detailView: VehicleDetailView!
    @IBOutlet private weak var nearestButton: UIButton!
    @IBOutlet private weak var refreshButton: UIButton!
    @IBOutlet private weak var detailViewBottomConstraint: NSLayoutConstraint!

    private let viewModel: MapViewModel

    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    private var selectedAnnotation: Vehicle?

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserTrackingButton()
        setupFindNearestButton()
        hideDetails()
        registerAnnotationViewClasses()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        fetchData()
    }

    private func registerAnnotationViewClasses() {
        mapView.register(AnnotationViewForNormal.self,
                         forAnnotationViewWithReuseIdentifier: AnnotationViewForNormal.ReuseID)
        mapView.register(AnnotationViewForWarning.self,
                         forAnnotationViewWithReuseIdentifier: AnnotationViewForWarning.ReuseID)
        mapView.register(AnnotationViewForError.self,
                         forAnnotationViewWithReuseIdentifier: AnnotationViewForError.ReuseID)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }

    private func fetchData() {
        viewModel.fetchData()
    }

    private func centerTo(annotation: MKAnnotation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    private func showDetails() {
        UIView.animate(withDuration: 0.5) {
            self.detailViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    private func hideDetails() {
        UIView.animate(withDuration: 0.5) {
            self.detailViewBottomConstraint.constant = -150
            self.view.layoutIfNeeded()
        }
    }

    private func setupUserTrackingButton() {
        mapView.showsUserLocation = true

        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.isHidden = false
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(userTrackingButton)
        NSLayoutConstraint.activate(
            [userTrackingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
             userTrackingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            ]
        )
    }

    private func setupFindNearestButton() {
        nearestButton.layer.cornerRadius = 10
        nearestButton.layer.borderColor = UIColor.borderColor?.cgColor
        nearestButton.layer.borderWidth = 2
    }

}

// MARK: - Action handlers
extension MapViewController {

    @IBAction func findButtonTapped(_ sender: Any) {
        hideDetails()

        let pins = mapView.annotations.compactMap { ($0 as? Vehicle) }
        guard let currentLocation = mapView.userLocation.location, !pins.isEmpty else {
            return
        }

        if let nearest = viewModel.findNearestPin(from: pins, currentLocation: currentLocation) as? Vehicle {
            centerTo(annotation: nearest)
            detailView.update(vehicle: nearest)
            showDetails()
        }
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        hideDetails()
        fetchData()
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Vehicle else { return nil }

        switch annotation.displayStatus() {
        case .normal:
            return AnnotationViewForNormal(annotation: annotation, reuseIdentifier: AnnotationViewForNormal.ReuseID)
        case .warning, .unknown:
            return AnnotationViewForWarning(annotation: annotation, reuseIdentifier: AnnotationViewForWarning.ReuseID)
        case .error:
            return AnnotationViewForError(annotation: annotation, reuseIdentifier: AnnotationViewForError.ReuseID)
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? Vehicle else { return }

        centerTo(annotation: view.annotation!)
        detailView.update(vehicle: selectedAnnotation)
        showDetails()
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hideDetails()
    }

}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let locationAuthorized = status == .authorizedWhenInUse
        userTrackingButton.isHidden = !locationAuthorized
    }
}

// MARK: - MapViewModelDelegate
extension MapViewController: MapViewModelDelegate {
    func dataFetched(annotations: [MKAnnotation]) {
        DispatchQueue.main.async {
            if !annotations.isEmpty {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
                self.mapView.showAnnotations(annotations, animated: true)
            }
        }
    }

    func showAlert(title: String, message: String, actions: [UIAlertAction]) {

        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for action in actions {
                alertController.addAction(action)
            }

            self.present(alertController, animated: true, completion: nil)
        }
    }
}

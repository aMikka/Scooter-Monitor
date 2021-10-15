//
//  AnnotationView.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import MapKit

private let scooterClusterID = "scooterCluster"

class AnnotationViewForNormal: MKMarkerAnnotationView {

    static let ReuseID = "normalAnnotationID"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = scooterClusterID
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.normalColor
        glyphImage = UIImage(named: "e-scooter")
    }
}

class AnnotationViewForWarning: MKMarkerAnnotationView {

    static let ReuseID = "warningAnnotationID"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = scooterClusterID
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.warningColor
        glyphImage = UIImage(named: "e-scooter")
    }
}

class AnnotationViewForError: MKMarkerAnnotationView {

    static let ReuseID = "errorAnnotationID"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = scooterClusterID
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.errorColor
        glyphImage = UIImage(named: "e-scooter")
    }
}

//
//  ClusterAnnotationView.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import MapKit

class ClusterAnnotationView: MKAnnotationView {

    static let ReuseID = "clusterAnnotationID"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let cluster = annotation as? MKClusterAnnotation {
            let totalVehicles = cluster.memberAnnotations.count

            image = drawChart(errorFraction: count(status: .error),
                              warningFraction: count(status: .warning),
                              to: totalVehicles,
                              wholeColor: UIColor.normalColor)

            if count(status: .error) > 0 {
                displayPriority = .defaultLow
            } else {
                displayPriority = .defaultHigh
            }
        }
    }

    private func drawChart(errorFraction: Int, warningFraction: Int, to whole: Int, wholeColor: UIColor?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in

            wholeColor?.setFill()
            var endAngle: CGFloat = 0
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

            if errorFraction > 0 {
                let piePath = UIBezierPath()
                UIColor.errorColor?.setFill()

                endAngle = CGFloat.pi * 2.0 * (CGFloat(errorFraction) / CGFloat(whole))
                piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                               startAngle: 0, endAngle: endAngle,
                               clockwise: true)

                piePath.addLine(to: CGPoint(x: 20, y: 20))
                piePath.close()
                piePath.fill()
            }

            if warningFraction > 0 {
                let piePath2 = UIBezierPath()
                UIColor.warningColor?.setFill()
                let warningAngle = CGFloat.pi * 2.0 * (CGFloat(warningFraction) / CGFloat(whole))
                let finalAngle = endAngle + warningAngle
                piePath2.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                               startAngle: endAngle, endAngle: finalAngle,
                               clockwise: true)
                piePath2.addLine(to: CGPoint(x: 20, y: 20))
                piePath2.close()
                piePath2.fill()
            }

            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()

            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)]
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }

    private func count(status: Vehicle.MonitoringStatus) -> Int {
        guard let cluster = annotation as? MKClusterAnnotation else {
            return 0
        }

        return cluster.memberAnnotations.filter { member -> Bool in
            guard let vehicle = member as? Vehicle else {
                fatalError("Found unexpected annotation type")
            }
            return vehicle.displayStatus() == status
        }.count
    }
}

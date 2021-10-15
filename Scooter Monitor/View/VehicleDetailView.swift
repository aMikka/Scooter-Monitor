//
//  VehicleDetailView.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 13.
//

import UIKit

class VehicleDetailView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        commonInit()
    }

    func update(vehicle: Vehicle) {
        numberLabel.text = "Battery charge: \(vehicle.battery ?? 0)%"
        statusLabel.text = "Status: " + (vehicle.state?.rawValue ?? "unknown")
    }

    private func commonInit() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true

        addSubview(view)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return nibView
        }
        return UIView()
    }
}

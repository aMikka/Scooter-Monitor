//
//  AppDelegate.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupWindow()
        return true
    }

    fileprivate func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MapViewController(viewModel: MapViewModelImpl(networking: MapDataNetworkingImpl()))
        window?.makeKeyAndVisible()
    }
}

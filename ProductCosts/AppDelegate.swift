//
//  AppDelegate.swift
//  ProductCosts
//
//  Created by Miron Dobrovsky on 23.11.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let loadingViewController = LoadingViewController()
        window?.rootViewController = loadingViewController
        window?.makeKeyAndVisible()

        let productModuleFactory = ProductModuleFactory()
        productModuleFactory.preloadRatesData(
            progressHandler: { progress, status in
                DispatchQueue.main.async {
                    loadingViewController.updateProgress(progress, status: status)
                }
            },
            completion: { ratesDataStorage in
                DispatchQueue.main.async {
                    let mainVC = productModuleFactory.make(ratesDataStorage: ratesDataStorage)
                    let nav = CustomNavigationController(rootViewController: mainVC)
                    self.window?.rootViewController = nav
                }
            }
        )
        return true
    }
}

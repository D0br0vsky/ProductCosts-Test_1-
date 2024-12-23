//
//  AppDelegate.swift
//  ProductCosts
//
//  Created by Miron Dobrovsky on 23.11.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var ratesDataStorage: RatesDataStorageProtocol?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        ProductModuleFactory.makeWithInitializedRates { [weak self] viewController in
            let nav = CustomNavigationController(rootViewController: viewController)
            self?.window?.rootViewController = nav
            self?.window?.makeKeyAndVisible()
        }
        return true
    }
}

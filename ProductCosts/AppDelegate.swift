//
//  AppDelegate.swift
//  ProductCosts
//
//  Created by Dobrovsky on 23.11.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var dataStorage: DataStorageProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let loadData = DataLoader()
        let service = DataService(loadData: loadData)
        let storage = DataStorage(service: service)
        self.dataStorage = storage
        storage.ratesLoad  {
            print("Rates initialized: \(storage.getRates())")
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let productModuleFactory = ProductModuleFactory(dataStorage: storage).make()
        let nav = UINavigationController(rootViewController: productModuleFactory)
        let appearance = UINavigationBarAppearance()
        
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}


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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let alphaModule = ProductModuleFactory().make()
        
        let nav = UINavigationController(rootViewController: alphaModule)
        
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


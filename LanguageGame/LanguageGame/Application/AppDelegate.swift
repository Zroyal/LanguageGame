//
//  AppDelegate.swift
//  LanguageGame
//
//  Created by Zeinab Khosravinia on 6/20/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.overrideUserInterfaceStyle = .light
                
        let vc = DefaultAppFactory().makeGameViewController()

        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()

        return true
    }


}


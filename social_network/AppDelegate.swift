//
//  AppDelegate.swift
//  social_network
//
//  Created by Radomyr Sidenko on 12.03.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if Auth.auth().currentUser != nil {
             let appDeligate = UIApplication.shared.delegate as? AppDelegate
             let main = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
            appDeligate?.window?.rootViewController = main
        }
        return true
    }

   


}


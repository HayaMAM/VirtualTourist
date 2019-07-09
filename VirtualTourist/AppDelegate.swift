//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Haya Mousa on 29/06/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataController.shared.load()
        return true
    }
    
    func saveViewContext() {
        try? DataController.shared.viewContext.save()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
}


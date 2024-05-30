//
//  diveManagerApp.swift
//  diveManager
//
//  Created by andrew austin on 2/27/24.
//

import SwiftUI

@main
struct diveManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataModel = DataModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dataModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationManager.shared.requestAuthorization()
        return true
    }
}

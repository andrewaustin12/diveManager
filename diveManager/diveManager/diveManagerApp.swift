//
//  diveManagerApp.swift
//  diveManager
//
//  Created by andrew austin on 2/27/24.
//

import SwiftUI
import TipKit

@main
struct diveManagerApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataModel = DataModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingTabView()
                }
            }
            .environmentObject(dataModel)
            .task {
                try? Tips.resetDatastore()
                try? Tips.configure([
                    //.displayFrequency(.immediate)
                    .datastoreLocation(.applicationDefault)
                ])
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationManager.shared.requestAuthorization()
        return true
    }
}

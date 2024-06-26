//
//  diveManagerApp.swift
//  diveManager
//
//  Created by andrew austin on 2/27/24.
//

import SwiftUI
import TipKit
import WishKit
import SwiftData

@main
struct diveManagerApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataModel = DataModel()
    let container: ModelContainer
    
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
            .modelContainer(container)
            .accentColor(Color.teal)
            .task {
                try? Tips.resetDatastore()
                try? Tips.configure([
                    //.displayFrequency(.immediate)
                    .datastoreLocation(.applicationDefault)
                ])
            }
        }
    }
    
    init() {
        WishKit.configure(with: "6B8355FC-F408-4F35-B92B-E6F92115D3EC")
        WishKit.config.buttons.addButton.bottomPadding = .large
        WishKit.theme.primaryColor = .accentColor
        WishKit.config.buttons.addButton.textColor = .setBoth(to: .white)
        WishKit.config.buttons.saveButton.textColor = .setBoth(to: .white)
        
        let schema = Schema([
            Certification.self,
            Course.self,
            DiveShop.self,
            EmailList.self,
            Expense.self,
            Goal.self,
            Invoice.self,
            InvoiceItem.self,
            MonthlyRevenue.self,
            MonthlyExpense.self,
            Session.self,
            Student.self
        ])
        let config = ModelConfiguration("DiveManager", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationManager.shared.requestAuthorization()
        return true
    }
}

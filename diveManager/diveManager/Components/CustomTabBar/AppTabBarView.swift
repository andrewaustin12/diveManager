//
//  AppTabBarView.swift
//  diveManager
//
//  Created by andrew austin on 2/27/24.
//

import SwiftUI

struct AppTabBarView: View {
    
    @State private var selection: String = "Home"
    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            HomeView()
                .tabBarItem(tab: .home, selection: $tabSelection)
            
            InvoicesListView()
                .tabBarItem(tab: .invoices, selection: $tabSelection)
            
            HistoryListView()
                .tabBarItem(tab: .history, selection: $tabSelection)
            
            SettingsView()
                .tabBarItem(tab: .settings, selection: $tabSelection)
        }
    }
}

#Preview {
    AppTabBarView()
}

extension AppTabBarView {
    
    private var defaultTabView: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            InvoicesListView()
                .tabItem {
                    Image(systemName: "doc")
                    Text("Invoices")
                }
            HistoryListView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                    Text("Profile")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

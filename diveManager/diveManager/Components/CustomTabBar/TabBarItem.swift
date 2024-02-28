//
//  TabBarItem.swift
//  diveManager
//
//  Created by andrew austin on 2/28/24.
//

import Foundation
import SwiftUI

//struct TabBarItem: Hashable {
//    let iconName: String
//    let title: String
//    let color: Color
//}

enum TabBarItem: Hashable {
    case home, invoices, history, settings
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .invoices: return "doc"
        case .history: return "list.bullet.rectangle.portrait"
        case .settings: return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .invoices: return "Invoices"
        case .history: return "History"
        case .settings: return "Settings"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return Color.blue
        case .invoices: return Color.red
        case .history: return Color.green
        case .settings: return Color.orange
        }
    }
}


//
//  Revenue.swift
//  diveManager
//
//  Created by andrew austin on 6/2/24.
//

import Foundation
import SwiftData

@Model
final class MonthlyRevenue: Identifiable {
    var id = UUID()
    var month: Date
    var totalRevenue: Double
    
    init(id: UUID = UUID(), month: Date, totalRevenue: Double) {
        self.id = id
        self.month = month
        self.totalRevenue = totalRevenue
    }
}

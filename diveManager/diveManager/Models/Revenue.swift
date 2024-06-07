//
//  Revenue.swift
//  diveManager
//
//  Created by andrew austin on 6/2/24.
//

import Foundation

struct MonthlyRevenue: Identifiable {
    var id = UUID()
    var month: Date
    var totalRevenue: Double
}

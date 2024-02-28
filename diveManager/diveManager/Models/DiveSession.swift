//
//  DiveSession.swift
//  diveManager
//
//  Created by andrew austin on 2/28/24.
//

import Foundation
struct DiveSession: Identifiable {
    var id = UUID()
    var location: String
    var numberOfDivers: Int
    var schoolName: String // Added school name
}

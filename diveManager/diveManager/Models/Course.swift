//
//  Course.swift
//  diveManager
//
//  Created by andrew austin on 2/28/24.
//

import Foundation

struct Course: Identifiable {
    var id = UUID()
    var agency: String
    var courseName: String
    var numberOfStudents: Int
    var schoolName: String // Added school name
}

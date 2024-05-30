//
//  EmailList.swift
//  diveManager
//
//  Created by andrew austin on 5/28/24.
//

import Foundation

struct EmailList: Identifiable {
    var id = UUID()
    var name: String
    var students: [Student]
}

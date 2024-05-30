//
//  InvoiceItem.swift
//  diveManager
//
//  Created by andrew austin on 5/28/24.
//

import Foundation

struct InvoiceItem: Identifiable, Codable {
    var id = UUID()
    var description: String
    var amount: Double
}


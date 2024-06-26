//
//  formattedDate.swift
//  diveManager
//
//  Created by andrew austin on 6/11/24.
//

import Foundation


struct Formatters {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()

    static func formatYear(_ year: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.usesGroupingSeparator = false
        return numberFormatter.string(from: NSNumber(value: year)) ?? "\(year)"
    }
}


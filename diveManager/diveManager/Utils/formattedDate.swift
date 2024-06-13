//
//  formattedDate.swift
//  diveManager
//
//  Created by andrew austin on 6/11/24.
//

import Foundation

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yy"
    return formatter.string(from: date)
}

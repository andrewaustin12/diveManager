//
//  DiveManager.swift
//  diveManager
//
//  Created by andrew austin on 2/28/24.
//

import Foundation

class DiveManager: ObservableObject {
    @Published var courses: [Course] = []
    @Published var diveSessions: [DiveSession] = []
}

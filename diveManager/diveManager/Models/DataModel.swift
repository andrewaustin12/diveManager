//
//  DataModel.swift
//  diveManager
//
//  Created by andrew austin on 5/28/24.
//

import Foundation
import SwiftUI
import Combine

import Foundation

class DataModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var diveShops: [DiveShop] = []
    @Published var emailLists: [EmailList] = []
    @Published var expenses: [Expense] = []
    @Published var invoices: [Invoice] = []
    @Published var students: [Student] = []
    @Published var certifications: [Certification] = []
    @Published var goals: [Goal] = []
}

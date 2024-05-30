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
    @Published var courses: [Course] = MockData.courses
    @Published var diveShops: [DiveShop] = MockData.diveShops
    @Published var emailLists: [EmailList] = MockData.emailLists
    @Published var expenses: [Expense] = MockData.expenses
    @Published var invoices: [Invoice] = MockData.invoices
    @Published var students: [Student] = MockData.students
}


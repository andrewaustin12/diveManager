//
//  HistoryListView.swift
//  diveManager
//
//  Created by andrew austin on 2/28/24.
//

import SwiftUI

struct HistoryListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Courses Taught") {
                    Text("PADI OPEN WATER")
                }
                Section("Students") {
                    Text("43")
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryListView()
}

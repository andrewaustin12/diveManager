//
//  InvoicesListView.swift
//  diveManager
//
//  Created by andrew austin on 2/28/24.
//

import SwiftUI

struct InvoicesListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Current") {
                    Text("N/A")
                }
                Section("Past Due") {
                    Text("N/A")
                }
            }
            .navigationTitle("Invoices")
        }
    }
}

#Preview {
    InvoicesListView()
}

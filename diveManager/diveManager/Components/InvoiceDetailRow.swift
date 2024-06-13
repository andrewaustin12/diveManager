//
//  InvoiceDetailRow.swift
//  diveManager
//
//  Created by andrew austin on 6/11/24.
//

import SwiftUI

struct InvoiceDetailRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    InvoiceDetailRow(title: "Apeks Regs", value: "1200")
}

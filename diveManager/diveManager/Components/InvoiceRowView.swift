//
//  InvoiceRowView.swift
//  diveManager
//
//  Created by andrew austin on 6/11/24.
//

import SwiftUI

struct InvoiceRow: View {
    var invoice: Invoice
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(invoice.billingType == .student ? "\(invoice.student?.firstName ?? "") \(invoice.student?.lastName ?? "")" : invoice.diveShop?.name ?? "")
                    .font(.headline)
                Text("Amount: \(currentCurrencySymbol)\(invoice.amount, specifier: "%.2f")")
                    .font(.subheadline)
                Text("Due: \(formattedDate(invoice.dueDate))")
                    .font(.subheadline)
            }
            Spacer()
            Text(invoice.isPaid ? "Paid" : "Unpaid")
                .foregroundColor(invoice.isPaid ? .green : .red)
                .bold()
                .padding(7)
                .background(invoice.isPaid ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .cornerRadius(8)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy"
        return formatter.string(from: date)
    }
}

#Preview {
    InvoiceRow(invoice: DataModel().invoices.first!)
        .environmentObject(DataModel())
}

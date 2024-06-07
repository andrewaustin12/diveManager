import SwiftUI
import MessageUI

struct InvoiceDetailView: View {
    @Binding var invoice: Invoice
    @State private var showingMailCompose = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Invoice Details")) {
                    InvoiceDetailRow(title: "Billed To", value: invoice.billingType == .student ? "\(invoice.student?.firstName ?? "") \(invoice.student?.lastName ?? "")" : invoice.diveShop?.name ?? "")
                    InvoiceDetailRow(title: "Amount", value: numberFormatter.string(from: NSNumber(value: invoice.amount)) ?? "$0.00")
                    InvoiceDetailRow(title: "Date", value: formattedDate(invoice.date))
                    InvoiceDetailRow(title: "Due Date", value: formattedDate(invoice.dueDate))
                    StatusToggleView(isPaid: $invoice.isPaid)
                }
                
                if !invoice.items.isEmpty {
                    Section(header: Text("Items")) {
                        ForEach(invoice.items) { item in
                            HStack {
                                Text(item.description)
                                Spacer()
                                Text(numberFormatter.string(from: NSNumber(value: item.amount)) ?? "$0.00")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        self.showingMailCompose = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Send Invoice via Email")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Set Notification")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingMailCompose) {
            if MFMailComposeViewController.canSendMail() {
                MailComposeView(
                    result: self.$mailResult,
                    subject: "Invoice Details",
                    recipients: [self.invoice.billingType == .student ? (self.invoice.student?.email ?? "") : (self.invoice.diveShop?.address ?? "")],
                    messageBody: self.composeEmailBody()
                )
            } else {
                Text("Mail services are not available")
            }
        }
        .navigationTitle("Invoice Detail")
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func composeEmailBody() -> String {
        let recipientName = invoice.billingType == .student ? "\(invoice.student?.firstName ?? "") \(invoice.student?.lastName ?? "")" : (invoice.diveShop?.name ?? "")
        let itemDetails = invoice.items.map { "\($0.description): \(numberFormatter.string(from: NSNumber(value: $0.amount)) ?? "$0.00")" }.joined(separator: "\n")
        return """
        Hello \(recipientName),

        Here are the details of your invoice:

        Amount: \(numberFormatter.string(from: NSNumber(value: invoice.amount)) ?? "$0.00")
        Date: \(formattedDate(invoice.date))
        Due Date: \(formattedDate(invoice.dueDate))
        Status: \(invoice.isPaid ? "Paid" : "Unpaid")

        Items:
        \(itemDetails)

        Thank you,
        Your Dive Manager
        """
    }
}

struct StatusToggleView: View {
    @Binding var isPaid: Bool

    var body: some View {
        HStack {
            Text("Status")
            Spacer()
            Toggle(isOn: $isPaid) {
                Text(isPaid ? "Paid" : "Unpaid")
                    .foregroundColor(isPaid ? .green : .red)
                    .bold()
                    .padding(7)
                    .background(isPaid ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
        }
    }
}

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

struct InvoiceDetailView_Previews: PreviewProvider {
    @State static var invoice = MockData.invoices[0]

    static var previews: some View {
        InvoiceDetailView(invoice: $invoice)
    }
}

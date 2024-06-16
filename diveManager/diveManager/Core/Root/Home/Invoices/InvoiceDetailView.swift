import SwiftUI
import MessageUI

struct InvoiceDetailView: View {
    @Binding var invoice: Invoice
    @EnvironmentObject var dataModel: DataModel
    @State private var showingMailCompose = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var showingAddItemView = false
    @State private var isEditing = false
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currentCurrencySymbol
        return formatter
    }
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Invoice Details")) {
                    if isEditing {
                        TextField("Billed To", text: Binding(
                            get: { invoice.billingType == .student ? "\(invoice.student?.firstName ?? "") \(invoice.student?.lastName ?? "")" : invoice.diveShop?.name ?? "" },
                            set: { newValue in
                                if invoice.billingType == .student {
                                    let names = newValue.split(separator: " ")
                                    invoice.student?.firstName = String(names.first ?? "")
                                    invoice.student?.lastName = names.count > 1 ? String(names.last ?? "") : ""
                                } else {
                                    invoice.diveShop?.name = newValue
                                }
                            }
                        ))
                        TextField("Amount", value: $invoice.amount, formatter: numberFormatter)
                        DatePicker("Date", selection: $invoice.date, displayedComponents: .date)
                        DatePicker("Due Date", selection: $invoice.dueDate, displayedComponents: .date)
                        StatusToggleView(isPaid: $invoice.isPaid)
                    } else {
                        InvoiceDetailRow(title: "Billed To", value: invoice.billingType == .student ? "\(invoice.student?.firstName ?? "") \(invoice.student?.lastName ?? "")" : invoice.diveShop?.name ?? "")
                        InvoiceDetailRow(title: "Amount", value: numberFormatter.string(from: NSNumber(value: invoice.amount)) ?? "\(currentCurrencySymbol)0.00")
                        InvoiceDetailRow(title: "Date", value: formattedDate(invoice.date))
                        InvoiceDetailRow(title: "Due Date", value: formattedDate(invoice.dueDate))
                        StatusToggleView(isPaid: $invoice.isPaid)
                    }
                }
                
                if !invoice.items.isEmpty {
                    Section(header: HStack {
                        Text("Items")
                        Spacer()
                        Button(action: {
                            showingAddItemView = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }) {
                        ForEach(invoice.items) { item in
                            HStack {
                                Text(item.description)
                                Spacer()
                                Text(numberFormatter.string(from: NSNumber(value: item.amount)) ?? "\(currentCurrencySymbol)0.00")
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
                        // Insert notification
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
        .navigationBarItems(trailing: Button(action: {
            isEditing.toggle()
            if !isEditing {
                saveChanges()
            }
        }) {
            Text(isEditing ? "Save" : "Edit")
        })
        .sheet(isPresented: $showingAddItemView) {
            AddInvoiceItemView(items: $invoice.items)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yy"
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
    
    private func saveChanges() {
        if let index = dataModel.invoices.firstIndex(where: { $0.id == invoice.id }) {
            dataModel.invoices[index] = invoice
        }
    }
}

struct InvoiceDetailView_Previews: PreviewProvider {
    @State static var invoice = MockData.invoices[0]
    
    static var previews: some View {
        NavigationStack {
            InvoiceDetailView(invoice: $invoice)
                .environmentObject(DataModel())
        }
    }
}

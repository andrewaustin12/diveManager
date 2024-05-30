import SwiftUI
import Charts

struct InvoiceManagementView: View {
    @State private var invoices: [Invoice] = MockData.invoices
    @State private var showingAddInvoice = false
    @State private var selectedDateRange: DateRange = .currentMonth

    enum DateRange: String, CaseIterable, Identifiable {
        case currentMonth = "Current Month"
        case lastMonth = "Last Month"
        case lastThreeMonths = "Last 3 Months"
        
        var id: String { self.rawValue }
    }

    var filteredInvoices: [Invoice] {
        let now = Date()
        let calendar = Calendar.current
        let dateFilteredInvoices: [Invoice]
        
        switch selectedDateRange {
        case .currentMonth:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            dateFilteredInvoices = invoices.filter { $0.date >= startOfMonth }
        case .lastMonth:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let startOfLastMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth)!
            dateFilteredInvoices = invoices.filter { $0.date >= startOfLastMonth && $0.date < startOfMonth }
        case .lastThreeMonths:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let startOfThreeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: startOfMonth)!
            dateFilteredInvoices = invoices.filter { $0.date >= startOfThreeMonthsAgo }
        
        }

        return dateFilteredInvoices
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Date Range", selection: $selectedDateRange) {
                    ForEach(DateRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    Section {
                        InvoiceSummaryChartView(invoices: filteredInvoices)
                    }
                    ForEach(filteredInvoices) { invoice in
                        NavigationLink(destination: InvoiceDetailView(invoice: invoice)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(invoice.billingType == .student ? "\(invoice.student?.firstName ?? "") \(invoice.student?.lastName ?? "")" : invoice.diveShop?.name ?? "")
                                        .font(.headline)
                                    Text("Amount: $\(invoice.amount, specifier: "%.2f")")
                                        .font(.subheadline)
                                    Text("Due: \(formattedDate(invoice.dueDate))")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text(invoice.isPaid ? "Paid" : "Unpaid")
                                    .foregroundColor(invoice.isPaid ? .green : .red)
                            }
                        }
                    }
                    .onDelete(perform: deleteInvoice)
                }
                .scrollContentBackground(.automatic)
                .navigationTitle("Invoices")
                .toolbar {
                    Button(action: { showingAddInvoice = true }) {
                        Label("Add Invoice", systemImage: "plus")
                    }
                }
                .sheet(isPresented: $showingAddInvoice) {
                    AddInvoiceView(invoices: $invoices)
                }
            }
        }
    }

    func deleteInvoice(at offsets: IndexSet) {
        invoices.remove(atOffsets: offsets)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct InvoiceManagementView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceManagementView()
    }
}

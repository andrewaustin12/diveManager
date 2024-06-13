import SwiftUI

struct InvoiceManagementView: View {
    @State private var invoices: [Invoice] = MockData.invoices
    @State private var selectedInvoice: Invoice? = nil
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
        switch selectedDateRange {
        case .currentMonth:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            return invoices.filter { $0.date >= startOfMonth }
        case .lastMonth:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let startOfLastMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth)!
            return invoices.filter { $0.date >= startOfLastMonth && $0.date < startOfMonth }
        case .lastThreeMonths:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let startOfThreeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: startOfMonth)!
            return invoices.filter { $0.date >= startOfThreeMonthsAgo }
        }
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
                .padding(.bottom, 5)
                
                List {
                    Section {
                        InvoiceSummaryChartView(invoices: filteredInvoices)
                    }
                    ForEach(filteredInvoices) { invoice in
                        NavigationLink(destination: InvoiceDetailView(invoice: binding(for: invoice))) {
                            InvoiceRow(invoice: invoice)
                        }
                    }
                    .onDelete(perform: deleteInvoice)
                }
                .toolbar {
                    Button(action: { showingAddInvoice = true }) {
                        Label("Add Invoice", systemImage: "plus")
                    }
                }
                .sheet(isPresented: $showingAddInvoice) {
                    AddInvoiceView(invoices: $invoices)
                }
                .navigationTitle("Invoices")
            }
        }
    }

    func binding(for invoice: Invoice) -> Binding<Invoice> {
        guard let index = invoices.firstIndex(where: { $0.id == invoice.id }) else {
            fatalError("Invoice not found")
        }
        return $invoices[index]
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
        NavigationStack {
            InvoiceManagementView()
                .environmentObject(DataModel())
        }
        
    }
}

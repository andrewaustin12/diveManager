import SwiftUI
import SwiftData

struct RevenueView: View {
    @Environment(\.modelContext) private var context // Use the SwiftData model context environment
    @Query private var expenses: [Expense]
    @Query private var invoices: [Invoice]
    @StateObject private var revenueVM = RevenueViewModel()
    @State private var showingAddRevenueView = false
    @State private var exportURL: URL?
    @State private var isRevenueExpanded = true
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var showingPDFPreview = false

    
    var yearToDateRevenue: Double {
        let calendar = Calendar.current
        return invoices
            .filter { calendar.component(.year, from: $0.date) == selectedYear }
            .reduce(0) { $0 + $1.amount }
    }
    
    var revenueByMonth: [(month: String, invoices: [Invoice], total: Double)] {
        let calendar = Calendar.current

        let filteredInvoices = invoices.filter {
            calendar.component(.year, from: $0.date) == selectedYear
        }

        let groupedInvoices = Dictionary(grouping: filteredInvoices, by: { invoice in
            calendar.date(from: calendar.dateComponents([.year, .month], from: invoice.date))!
        }).mapValues { invoices in
            (invoices, invoices.reduce(0) { $0 + $1.amount })
        }

        let sortedGroupedInvoices = groupedInvoices.sorted { $0.key < $1.key }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"

        return sortedGroupedInvoices.map { key, value in
            (month: dateFormatter.string(from: key), invoices: value.0, total: value.1)
        }
    }
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    VStack(alignment: .leading) {
                        Text("Total")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("\(currentCurrencySymbol)\(yearToDateRevenue, specifier: "%.2f")")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Section("Overview") {
                        AverageRevenueChartView(selectedYear: selectedYear)
                    }

                    Section("Details") {
                        ForEach(revenueByMonth, id: \.month) { monthData in
                            DisclosureGroup {
                                ForEach(monthData.invoices) { invoice in
                                    HStack {
                                        Text("\(invoice.date, formatter: dateFormatter)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(invoice.student?.firstName ?? invoice.diveShop?.name ?? "Unknown")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("\(invoice.amount, specifier: "\(currentCurrencySymbol)%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                    }
                                    .padding(.vertical, 2)
                                }
                            } label: {
                                HStack {
                                    Text(monthData.month)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(currentCurrencySymbol)\(monthData.total, specifier: "%.2f")")
                                        .bold()
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                .listSectionSpacing(1)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Menu {
                                Picker("Select Year", selection: $selectedYear) {
                                    ForEach(getLastFourYearsRevenue(), id: \.self) { year in
                                        Text(formatYear(year)).tag(year)
                                    }
                                }
                            } label: {
                                Text(formatYear(selectedYear))
                                    .font(.headline)
                            }

                            Menu {
//                                Button(action: { showingAddRevenueView = true }) {
//                                    Label("Add Revenue", systemImage: "plus")
//                                }
                                Button(action: { revenueVM.exportRevenueData(as: .csv) }) {
                                    Label("Export as CSV", systemImage: "square.and.arrow.up")
                                }
                                Button(action: {
                                    revenueVM.exportRevenueData(as: .pdf)
                                }) {
                                    Label("Export as PDF", systemImage: "square.and.arrow.up")
                                }
                            } label: {
                                Label("More", systemImage: "ellipsis.circle")
                            }
                        }
                    }
                }
//                .sheet(isPresented: $showingAddRevenueView) {
//                    AddInvoiceView(invoices: $revenueVM.invoices)
//                        .environmentObject(dataModel)
//                }
//                .sheet(isPresented: $revenueVM.showingPDFPreview) {
//                    if let url = revenueVM.exportURL {
//                        PDFPreviewView(url: url)
//                    }
//                }
//                .onAppear {
//                    revenueVM.loadInvoices(from: dataModel)
//                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func getLastFourYearsRevenue() -> [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (0..<4).map { currentYear - $0 }
    }
    
    func formatYear(_ year: Int) -> String {
        return Formatters.formatYear(year)
    }
}

struct RevenueView_Previews: PreviewProvider {
    static var previews: some View {
        RevenueView()
            .environmentObject(DataModel())
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM "
    return formatter
}()

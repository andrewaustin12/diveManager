import SwiftUI

struct RevenueView: View {
    @EnvironmentObject var dataModel: DataModel
    @StateObject private var revenueVM = RevenueViewModel()
    @State private var showingAddRevenueView = false
    @State private var showingExportSheet = false
    @State private var exportURL: URL?
    @State private var exportType = ExportType.csv
    @State private var isRevenueExpanded = true
    @State private var selectedYear = Calendar.current.component(.year, from: Date())

    enum ExportType {
        case csv, pdf 
    }

    var yearToDateRevenue: Double {
        let calendar = Calendar.current
        return revenueVM.invoices
            .filter { calendar.component(.year, from: $0.date) == selectedYear }
            .reduce(0) { $0 + $1.amount }
    }

    var revenueByMonth: [(month: String, invoices: [Invoice], total: Double)] {
        let calendar = Calendar.current

        let filteredInvoices = revenueVM.invoices.filter {
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
                                    VStack(alignment: .leading) {
                                        Text(invoice.student?.firstName ?? invoice.diveShop?.name ?? "Unknown")
                                            .font(.headline)
                                        Text("Amount: \(invoice.amount, specifier: "\(currentCurrencySymbol)%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("Date: \(invoice.date, formatter: dateFormatter)")
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
                                    ForEach(getLastFourYears(), id: \.self) { year in
                                        Text(formatYear(year)).tag(year)
                                    }
                                }
                            } label: {
                                Text(formatYear(selectedYear))
                                    .font(.headline)
                            }

                            Menu {
                                Button(action: { showingAddRevenueView = true }) {
                                    Label("Add Revenue", systemImage: "plus")
                                }
                                Button(action: { exportData(as: .csv) }) {
                                    Label("Export as CSV", systemImage: "square.and.arrow.up")
                                }
                                Button(action: { exportData(as: .pdf) }) {
                                    Label("Export as PDF", systemImage: "square.and.arrow.up")
                                }
                            } label: {
                                Label("More", systemImage: "ellipsis.circle")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingAddRevenueView) {
                    AddInvoiceView(invoices: $revenueVM.invoices)
                        .environmentObject(dataModel)
                }
                .sheet(isPresented: $showingExportSheet) {
                    if let url = exportURL {
                        ActivityViewController(activityItems: [url])
                    }
                }
                .onAppear {
                    revenueVM.loadInvoices(from: dataModel)
                }
            }
            .navigationTitle("Revenue")
        }
    }

    private func getLastFourYears() -> [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (0..<4).map { currentYear - $0 }
    }

    private func exportData(as type: ExportType) {
        exportType = type
        let fileName: String
        let fileURL: URL

        switch type {
        case .csv:
            let content = generateCSV()
            fileName = "financial_data.csv"

            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                fileURL = documentDirectory.appendingPathComponent(fileName)

                do {
                    try content.write(to: fileURL, atomically: true, encoding: .utf8)
                    exportURL = fileURL
                    showingExportSheet = true
                } catch {
                    print("Error writing file: \(error.localizedDescription)")
                }
            }

        case .pdf:
            if let pdfData = generatePDF() {
                fileName = "financial_data.pdf"

                if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    fileURL = documentDirectory.appendingPathComponent(fileName)

                    do {
                        try pdfData.write(to: fileURL, options: .atomic)
                        exportURL = fileURL
                        showingExportSheet = true
                    } catch {
                        print("Error writing file: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Failed to generate PDF")
            }
        }
    }

    private func generateCSV() -> String {
        var csvString = "Type,Description,Amount,Date,Due Date,Status\n"

        for invoice in revenueVM.invoices {
            let status = invoice.isPaid ? "Paid" : "Unpaid"
            let dueDate = dateFormatter.string(from: invoice.dueDate)
            csvString += "Invoice,\(invoice.student?.firstName ?? invoice.diveShop?.name ?? "Unknown"),\(invoice.amount),\(dateFormatter.string(from: invoice.date)),\(dueDate),\(status)\n"
        }

        for expense in dataModel.expenses {
            csvString += "Expense,\(expense.description),\(expense.amount),\(dateFormatter.string(from: expense.date)),,\n"
        }

        return csvString
    }

    private func generatePDF() -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Financial Report",
            kCGPDFContextAuthor: "Your Company",
            kCGPDFContextTitle: "Financial Report"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11.0 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in
            context.beginPage()
            let title = "Financial Report\n"
            let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
            let titleString = NSAttributedString(string: title, attributes: attributes)
            titleString.draw(at: CGPoint(x: 36, y: 36))

            var yPosition = 60.0
            let leftPadding = 36.0

            for invoice in revenueVM.invoices {
                let invoiceString = "Invoice - \(invoice.student?.firstName ?? invoice.diveShop?.name ?? "Unknown"): \(invoice.amount) - Due: \(dateFormatter.string(from: invoice.dueDate)) - \(invoice.isPaid ? "Paid" : "Unpaid")"
                let attributedString = NSAttributedString(string: invoiceString)
                attributedString.draw(at: CGPoint(x: leftPadding, y: yPosition))
                yPosition += 20.0
            }

            for expense in dataModel.expenses {
                let expenseString = "Expense - \(expense.description): \(expense.amount) - Date: \(dateFormatter.string(from: expense.date))"
                let attributedString = NSAttributedString(string: expenseString)
                attributedString.draw(at: CGPoint(x: leftPadding, y: yPosition))
                yPosition += 20.0
            }
        }

        return data
    }

    private func formatYear(_ year: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        numberFormatter.usesGroupingSeparator = false
        return numberFormatter.string(from: NSNumber(value: year)) ?? "\(year)"
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy"
    return formatter
}()

struct RevenueView_Previews: PreviewProvider {
    static var previews: some View {
        RevenueView()
            .environmentObject(DataModel())
    }
}

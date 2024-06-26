import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(\.modelContext) private var context // Use the SwiftData model context environment
    @Query private var expenses: [Expense] // Use SwiftData query to fetch expenses
    @State private var showingAddExpenseView = false
    @State private var showingExportSheet = false
    @State private var exportURL: URL?
    @State private var isExpensesExpanded = true
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var showingPDFPreview = false
    
    enum ExportType {
        case csv, pdf
    }
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var yearToDateExpenses: Double {
        let calendar = Calendar.current
        return expenses
            .filter { calendar.component(.year, from: $0.date) == selectedYear }
            .reduce(0) { $0 + $1.amount }
    }

    var expensesByMonth: [(month: String, expenses: [Expense], total: Double)] {
        let calendar = Calendar.current

        let filteredExpenses = expenses.filter {
            calendar.component(.year, from: $0.date) == selectedYear
        }

        let groupedExpenses = Dictionary(grouping: filteredExpenses, by: { expense in
            calendar.date(from: calendar.dateComponents([.year, .month], from: expense.date))!
        }).mapValues { expenses in
            (expenses, expenses.reduce(0) { $0 + $1.amount })
        }

        let sortedGroupedExpenses = groupedExpenses.sorted { $0.key < $1.key }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"

        return sortedGroupedExpenses.map { key, value in
            (month: dateFormatter.string(from: key), expenses: value.0, total: value.1)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    VStack(alignment: .leading) {
                        Text("Total")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("\(currentCurrencySymbol)\(yearToDateExpenses, specifier: "%.2f")")
                            .font(.largeTitle)
                            .bold()
                    }
                    Section("Overview") {
                        AverageExpensesChartView(selectedYear: selectedYear)
                    }
                    Section("Details") {
                        ForEach(expensesByMonth, id: \.month) { monthData in
                            DisclosureGroup {
                                ForEach(monthData.expenses) { expense in
                                    HStack {
                                        Text("\(expense.date, formatter: dateFormatter)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(expense.expenseDescription)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text("\(expense.amount, specifier: "\(currentCurrencySymbol)%.2f")")
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
                                    Text("\(currentCurrencySymbol)\(monthData.total, specifier: "%.f")")
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
                                Button(action: { showingAddExpenseView = true }) {
                                    Label("Add Expense", systemImage: "plus")
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
                .sheet(isPresented: $showingAddExpenseView) {
                    AddExpenseView()
                        .environment(\.modelContext, context) // Use SwiftData context
                }
                .sheet(isPresented: $showingPDFPreview) {
                    if let url = exportURL {
                        PDFPreviewView(url: url)
                    }
                }
                .onChange(of: selectedYear) { _ in
                    loadExpenses()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func loadExpenses() {
        // No need to manually load expenses anymore, they are fetched automatically by the @Query property
        print("Expenses loaded: \(expenses.count) for year \(selectedYear)")
    }

    private func getLastFourYears() -> [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (0..<4).map { currentYear - $0 }
    }

    private func exportData(as type: ExportType) {
        let fileName: String
        let fileURL: URL

        switch type {
        case .csv:
            let content = generateCSV()
            fileName = "expenses_data.csv"

            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                fileURL = documentDirectory.appendingPathComponent(fileName)

                do {
                    try content.write(to: fileURL, atomically: true, encoding: .utf8)
                    exportURL = fileURL
                    showingPDFPreview = true
                    print("CSV file written successfully: \(fileURL)")
                } catch {
                    print("Error writing file: \(error.localizedDescription)")
                }
            }

        case .pdf:
            if let pdfData = generatePDF() {
                fileName = "expenses_data_\(selectedYear).pdf"

                if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    fileURL = documentDirectory.appendingPathComponent(fileName)

                    do {
                        try pdfData.write(to: fileURL, options: .atomic)
                        exportURL = fileURL
                        DispatchQueue.main.async {
                            self.showingPDFPreview = true
                            print("PDF file written successfully: \(fileURL)")
                        }
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

        for expense in expenses {
            csvString += "Expense,\(expense.expenseDescription),\(expense.amount),\(Formatters.dateFormatter.string(from: expense.date)),,\n"
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

        let data = renderer.pdfData { context in
            context.beginPage()

            // Header
            let headerFont = UIFont.boldSystemFont(ofSize: 18)
            let dateFont = UIFont.systemFont(ofSize: 12)

            // Financial Report title
            let reportTitle = "Expense Report"
            let reportTitleAttributes: [NSAttributedString.Key: Any] = [.font: headerFont]
            let reportTitleString = NSAttributedString(string: reportTitle, attributes: reportTitleAttributes)
            let reportTitleSize = reportTitleString.size()
            reportTitleString.draw(at: CGPoint(x: 36, y: 36))

            // Selected year
            let selectedYearString = "\(selectedYear)"
            let selectedYearAttributes: [NSAttributedString.Key: Any] = [.font: dateFont]
            let selectedYearAttributedString = NSAttributedString(string: selectedYearString, attributes: selectedYearAttributes)
            let selectedYearSize = selectedYearAttributedString.size()
            selectedYearAttributedString.draw(at: CGPoint(x: pageWidth - 36 - selectedYearSize.width, y: 42))

            // Draw line below header
            let lineYPosition = 36 + reportTitleSize.height + 6
            context.cgContext.move(to: CGPoint(x: 36, y: lineYPosition))
            context.cgContext.addLine(to: CGPoint(x: pageWidth - 36, y: lineYPosition))
            context.cgContext.strokePath()

            // Define starting positions
            var yPosition = lineYPosition + 20.0
            let leftPadding = 36.0
            let currencySymbol = UserDefaults.standard.currency.symbol

            // Summary Section
            let summaryFont = UIFont.boldSystemFont(ofSize: 14)
            let summaryAttributes: [NSAttributedString.Key: Any] = [.font: summaryFont]

            let totalExpenses = expenses
                .filter { Calendar.current.component(.year, from: $0.date) == selectedYear }
                .reduce(0) { $0 + $1.amount }
            let totalExpensesString = "Total Expenses: \(currencySymbol)\(String(format: "%.2f", totalExpenses))"
            let totalExpensesAttributedString = NSAttributedString(string: totalExpensesString, attributes: summaryAttributes)
            totalExpensesAttributedString.draw(at: CGPoint(x: leftPadding, y: yPosition))
            yPosition += 40.0

            // Draw Expenses header
            let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            let expenseHeader = NSAttributedString(string: "Expenses", attributes: headerAttributes)
            expenseHeader.draw(at: CGPoint(x: leftPadding, y: yPosition))
            yPosition += 24.0

            // Draw expenses
            for expense in expenses.filter({ Calendar.current.component(.year, from: $0.date) == selectedYear }) {
                let expenseString = "\(expense.expenseDescription): \(currencySymbol)\(String(format: "%.2f", expense.amount)) - Date: \(Formatters.dateFormatter.string(from: expense.date))"
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


struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Expense.self, configurations: config)
        
        return ExpensesView()
            .environmentObject(DataModel())
            .modelContainer(container) // Use model container for preview
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM "
    return formatter
}()

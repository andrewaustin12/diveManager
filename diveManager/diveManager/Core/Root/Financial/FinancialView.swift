import SwiftUI
import Charts
import PDFKit

enum DateFilter: String, CaseIterable, Identifiable {
    case sevenDays = "7 Days"
    case oneMonth = "1 Month"
    case quarterly = "Quarterly"
    case yearly = "Yearly"
    
    var id: String { self.rawValue }
}

enum PaymentFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case paid = "Paid"
    case unpaid = "Unpaid"
    
    var id: String { self.rawValue }
}

struct FinancialView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var showingAddExpenseView = false
    @State private var showingAddInvoiceView = false
    @State private var selectedDateFilter: DateFilter = .sevenDays
    @State private var selectedPaymentFilter: PaymentFilter = .all
    @State private var showingExportSheet = false
    @State private var exportURL: URL?
    @State private var exportType: ExportType = .csv
    @State private var isSummaryExpanded = true
    @State private var isInvoicesExpanded = true
    @State private var isExpensesExpanded = true
    
    enum ExportType {
        case csv, pdf
    }
    
    var filteredInvoices: [Invoice] {
        let now = Date()
        let startDate: Date
        
        switch selectedDateFilter {
        case .sevenDays:
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        case .oneMonth:
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        case .quarterly:
            startDate = Calendar.current.date(byAdding: .month, value: -3, to: now)!
        case .yearly:
            startDate = Calendar.current.date(byAdding: .year, value: -1, to: now)!
        }
        
        let dateFilteredInvoices = dataModel.invoices.filter { $0.date >= startDate }
        
        switch selectedPaymentFilter {
        case .all:
            return dateFilteredInvoices
        case .paid:
            return dateFilteredInvoices.filter { $0.isPaid }
        case .unpaid:
            return dateFilteredInvoices.filter { !$0.isPaid }
        }
    }
    
    var filteredExpenses: [Expense] {
        let now = Date()
        let startDate: Date
        
        switch selectedDateFilter {
        case .sevenDays:
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        case .oneMonth:
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        case .quarterly:
            startDate = Calendar.current.date(byAdding: .month, value: -3, to: now)!
        case .yearly:
            startDate = Calendar.current.date(byAdding: .year, value: -1, to: now)!
        }
        
        return dataModel.expenses.filter { $0.date >= startDate }
    }
    
    private var dateRangeText: String {
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            
            let startDate: Date
            
            switch selectedDateFilter {
            case .sevenDays:
                startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            case .oneMonth:
                startDate = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            case .quarterly:
                startDate = Calendar.current.date(byAdding: .month, value: -3, to: now)!
            case .yearly:
                startDate = Calendar.current.date(byAdding: .year, value: -1, to: now)!
            }
            
            let startMonth = Calendar.current.component(.month, from: startDate)
            let endMonth = Calendar.current.component(.month, from: now)
            let startYear = Calendar.current.component(.year, from: startDate)
            let endYear = Calendar.current.component(.year, from: now)
            
            if startMonth == endMonth && startYear == endYear {
                return "\(formatter.string(from: startDate))-\(formatter.string(from: now)), \(yearFormatter.string(from: now))"
            } else {
                let startFormatter = DateFormatter()
                startFormatter.dateFormat = "MMM d"
                let endFormatter = DateFormatter()
                endFormatter.dateFormat = "MMM d, yyyy"
                
                return "\(startFormatter.string(from: startDate)) - \(endFormatter.string(from: now))"
            }
        }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Picker("Filter by Date", selection: $selectedDateFilter) {
                        ForEach(DateFilter.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    
                    Text(dateRangeText)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    List {
                        Section(header: HStack {
                            Text("Summary")
                            Spacer()
                            Button(action: {
                                isSummaryExpanded.toggle()
                            }) {
                                Image(systemName: isSummaryExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.blue)
                            }
                        }) {
                            if isSummaryExpanded {
                                SummarySectionView(totalIncome: totalIncome(), totalExpenses: totalExpenses(), netIncome: netIncome())
                            }
                        }
                        
                        Section(header: HStack {
                            Text("Invoices")
                            
                            Menu {
                                Picker("Filter by Payment Status", selection: $selectedPaymentFilter) {
                                    ForEach(PaymentFilter.allCases) { filter in
                                        Text(filter.rawValue).tag(filter)
                                    }
                                }
                            } label: {
                                Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                            }
                            Spacer()
                            Button(action: {
                                isInvoicesExpanded.toggle()
                            }) {
                                Image(systemName: isInvoicesExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.blue)
                            }
                        }) {
                            if isInvoicesExpanded {
                                ForEach(filteredInvoices) { invoice in
                                    NavigationLink(destination: InvoiceDetailView(invoice: invoice)) {
                                        VStack(alignment: .leading) {
                                            Text(invoice.student?.firstName ?? invoice.diveShop?.name ?? "Unknown")
                                                .font(.headline)
                                            Text("Amount: \(invoice.amount, format: .currency(code: "USD"))")
                                                .font(.subheadline)
                                            Text("Due: \(invoice.dueDate, formatter: dateFormatter)")
                                                .font(.subheadline)
                                            Text(invoice.isPaid ? "Paid" : "Unpaid")
                                                .foregroundColor(invoice.isPaid ? .green : .red)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Section(header: HStack {
                            Text("Expenses")
                            Spacer()
                            Button(action: {
                                isExpensesExpanded.toggle()
                            }) {
                                Image(systemName: isExpensesExpanded ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.blue)
                            }
                        }) {
                            if isExpensesExpanded {
                                ForEach(filteredExpenses) { expense in
                                    VStack(alignment: .leading) {
                                        Text(expense.description)
                                            .font(.headline)
                                        Text("Amount: \(expense.amount, format: .currency(code: "USD"))")
                                            .font(.subheadline)
                                        Text("Date: \(expense.date, formatter: dateFormatter)")
                                            .font(.subheadline)
                                    }
                                }
                                .onDelete(perform: deleteExpense)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .listStyle(PlainListStyle())
                    .frame(maxWidth: min(geometry.size.width, 700))
                }
            }
            .navigationTitle("Financial Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddExpenseView = true }) {
                            Label("Add Expense", systemImage: "plus")
                        }
                        Button(action: { showingAddInvoiceView = true }) {
                            Label("Add Invoice", systemImage: "doc.text")
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
            .sheet(isPresented: $showingAddExpenseView) {
                AddExpenseView()
                    .environmentObject(dataModel)
            }
            .sheet(isPresented: $showingAddInvoiceView) {
                AddInvoiceView(invoices: $dataModel.invoices)
                    .environmentObject(dataModel)
            }
            .sheet(isPresented: $showingExportSheet) {
                if let url = exportURL {
                    ActivityViewController(activityItems: [url])
                }
            }
        }
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
        
        for invoice in dataModel.invoices {
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
            
            for invoice in dataModel.invoices {
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
            
            let summaryView = SummarySectionView(totalIncome: totalIncome(), totalExpenses: totalExpenses(), netIncome: netIncome())
            let summaryImage = summaryView.snapshot()
            summaryImage.draw(at: CGPoint(x: leftPadding, y: yPosition))
        }
        
        return data
    }
    
    private func totalIncome() -> Double {
        return filteredInvoices.reduce(0) { $0 + $1.amount }
    }
    
    private func totalExpenses() -> Double {
        return filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    private func netIncome() -> Double {
        return totalIncome() - totalExpenses()
    }
    
    private func deleteExpense(at offsets: IndexSet) {
        dataModel.expenses.remove(atOffsets: offsets)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct FinancialView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialView()
            .environmentObject(DataModel())
    }
}

struct SummarySectionView: View {
    let totalIncome: Double
    let totalExpenses: Double
    let netIncome: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("Total Income:")
                Spacer()
                Text("\(totalIncome, format: .currency(code: "USD"))")
            }
            HStack {
                Text("Total Expenses:")
                Spacer()
                Text("\(totalExpenses, format: .currency(code: "USD"))")
            }
            HStack {
                Text("Net Income:")
                Spacer()
                Text("\(netIncome, format: .currency(code: "USD"))")
                    .foregroundColor(netIncome >= 0 ? .green : .red)
            }
            
            Chart {
                BarMark(
                    x: .value("Category", "Total Income"),
                    y: .value("Amount", totalIncome)
                )
                .foregroundStyle(.blue)
                
                BarMark(
                    x: .value("Category", "Total Expenses"),
                    y: .value("Amount", totalExpenses)
                )
                .foregroundStyle(.red)
                
                BarMark(
                    x: .value("Category", "Net Income"),
                    y: .value("Amount", netIncome)
                )
                .foregroundStyle(netIncome >= 0 ? .green : .red)
            }
            .frame(height: 200)
        }
        .padding()
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

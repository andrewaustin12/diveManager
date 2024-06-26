import SwiftUI
import Charts
import PDFKit
import TipKit
import SwiftData

enum DateFilter: String, CaseIterable, Identifiable {
    case sevenDays = "7 Days"
    case oneMonth = "1 Month"
    case quarterly = "Quarterly"
    case yearly = "Yearly"
    case yearToDate = "YTD"
    
    var id: String { self.rawValue }
}

enum PaymentFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case paid = "Paid"
    case unpaid = "Unpaid"
    
    var id: String { self.rawValue }
}

enum ExportType {
    case pdf
}

struct FinancialView: View {
    @Environment(\.modelContext) private var context
    @Query private var expenses: [Expense]
    @Query private var invoices: [Invoice]
    @State private var showingAddExpenseView = false
    @State private var showingExpenseView = false
    @State private var showingRevenueView = false
    @State private var showingAddInvoiceView = false
    @State private var selectedDateFilter: DateFilter = .yearToDate
    @State private var selectedPaymentFilter: PaymentFilter = .all
    @State private var showingExportSheet = false
    @State private var showingPDFPreview = false
    @State private var exportURL: URL?
    @State private var exportType: ExportType = .pdf
    @State private var isSummaryExpanded = true
    @State private var isInvoicesExpanded = true
    @State private var isExpensesExpanded = true
    private var profitTip = EstProfitTip()
    private var taxTip = EstTaxTip()
    
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
        case .yearToDate:
            startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: now))!
        }
        
        let dateFilteredInvoices = invoices.filter { $0.date >= startDate }
        
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
        case .yearToDate:
            startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: now))!
        }
        
        return expenses.filter { $0.date >= startDate }
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
        case .yearToDate:
            startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: now))!
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
    
    private var currentDayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
    
    private var estimatedAnnualProfit: Double {
        let totalNetIncome = invoices.reduce(0) { $0 + $1.amount } - expenses.reduce(0) { $0 + $1.amount }
        let dailyProfit = totalNetIncome / Double(currentDayOfYear)
        return dailyProfit * 365
    }
    
    private var estimatedTaxes: Double {
        return calculateEstimatedTaxes(for: estimatedAnnualProfit)
    }
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }
    
    var totalRevenue: Double {
        filteredInvoices.reduce(0) { $0 + $1.amount }
    }
    
    var commission: Double {
        calculateCommission(for: totalRevenue)
    }
    
    private var estimatedAnnualCommission: Double {
        let totalRevenue = invoices.reduce(0) { $0 + $1.amount }
        let dailyRevenue = totalRevenue / Double(currentDayOfYear)
        let estimatedAnnualRevenue = dailyRevenue * 365
        return calculateCommission(for: estimatedAnnualRevenue)
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
                    
                    ScrollView {
                        
                        VStack(alignment: .leading) {
                            Text("\(dateRangeText)")
                                .font(.title)
                                .bold()
                        }
        
                        GroupBox{
                            SummarySectionView(totalIncome: totalIncome(), totalExpenses: totalExpenses(), netIncome: netIncome())
                        }
                        
                        // If commission rate is set > 0 show the group box
                        HStack {
                            GroupBox {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Current Commision")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "info.circle")
                                            .onTapGesture {
                                                EstProfitTip.isProfitTaped.toggle()
                                            }
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                    
                                    Text("\(currentCurrencySymbol)\(commission, specifier: "%.f")")
                                        .font(.title)
                                        .bold()
                                }
                                
                            }
                            
                            GroupBox {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Est. 2024 Commision")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "info.circle")
                                            .onTapGesture {
                                                EstProfitTip.isProfitTaped.toggle()
                                            }
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    
                                    
                                    Text("\(currentCurrencySymbol)\(estimatedAnnualCommission, specifier: "%.f")")
                                        .font(.title)
                                        .bold()
                                }
                            }
                        }
                        
                        HStack {
                            
                            GroupBox {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Est. 2024 Profit")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "info.circle")
                                            .onTapGesture {
                                                EstProfitTip.isProfitTaped.toggle()
                                            }
                                        
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    
                                    
                                    Text("\(currentCurrencySymbol)\(estimatedAnnualProfit, specifier: "%.f")")
                                        .font(.title)
                                        .bold()
                                }
                            }
                            
                            GroupBox {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Est. 2024 Taxes")
                                        
                                        Spacer()
                                        Image(systemName: "info.circle")
                                            .onTapGesture {
                                                EstTaxTip.isTaxTapped.toggle()
                                            }
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    Text("\(currentCurrencySymbol)\(estimatedTaxes, specifier: "%.f")")
                                        .font(.title)
                                        .bold()
                                }
                            }
                        }
                        .overlay {
                            TipView(profitTip)
                                .tipViewStyle(MiniTipViewStyle())
                                .shadow(radius: 2)
                                .offset(x: -27, y: 43)
                        }
                        .overlay {
                            TipView(taxTip)
                                .tipViewStyle(HeadlineTipViewStyle())
                                .shadow(radius: 2)
                                .offset(x: 55, y: 43)
                        }
                        
                        GroupBox {
                            RevenueStreamsBarChart(filteredInvoices: filteredInvoices)
                        }
                    }
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                    .frame(maxWidth: min(geometry.size.width, 700))
                }
            }
            //.navigationTitle("Financial Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddExpenseView = true }) {
                            Label("Add Expense", systemImage: "plus")
                        }
                        Button(action: { showingAddInvoiceView = true }) {
                            Label("Add Invoice", systemImage: "doc.text")
                        }
                        
                        Button(action: { exportData(as: .pdf) }) {
                            Label("Export as PDF", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }
//            .sheet(isPresented: $showingAddExpenseView) {
//                AddExpenseView()
//                    .environmentObject(dataModel)
//            }
            .sheet(isPresented: $showingAddInvoiceView) {
                AddInvoiceView()
                    .environment(\.modelContext, context)
            }
            .sheet(isPresented: $showingPDFPreview) {
                if let url = exportURL {
                    PDFPreviewView(url: url)
                }
            }
            
        }
    }

    private func exportData(as type: ExportType) {
        exportType = type
        let fileName: String
        let fileURL: URL

        switch type {
        case .pdf:
            if let pdfData = generatePDF() {
                fileName = "financial_data.pdf"

                if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    fileURL = documentDirectory.appendingPathComponent(fileName)

                    do {
                        try pdfData.write(to: fileURL, options: .atomic)
                        exportURL = fileURL
                        showingPDFPreview = true
                    } catch {
                        print("Error writing file: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Failed to generate PDF")
            }
        }
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
            let reportTitle = "Financial Report"
            let reportTitleAttributes: [NSAttributedString.Key: Any] = [.font: headerFont]
            let reportTitleString = NSAttributedString(string: reportTitle, attributes: reportTitleAttributes)
            let reportTitleSize = reportTitleString.size()
            reportTitleString.draw(at: CGPoint(x: 36, y: 36))
            
            // Date range
            let dateRange = dateRangeText
            let dateRangeAttributes: [NSAttributedString.Key: Any] = [.font: dateFont]
            let dateRangeString = NSAttributedString(string: dateRange, attributes: dateRangeAttributes)
            let dateRangeSize = dateRangeString.size()
            dateRangeString.draw(at: CGPoint(x: pageWidth - 36 - dateRangeSize.width, y: 42))
            
            // Draw line below header
            let lineYPosition = 36 + reportTitleSize.height + 6
            context.cgContext.move(to: CGPoint(x: 36, y: lineYPosition))
            context.cgContext.addLine(to: CGPoint(x: pageWidth - 36, y: lineYPosition))
            context.cgContext.strokePath()
            
            // Summary Section
            var bodyYPosition = lineYPosition + 20.0
            let leftPadding = 36.0
            let columnWidth = pageWidth - leftPadding * 2
            let currencySymbol = currentCurrencySymbol

            let summaryFont = UIFont.boldSystemFont(ofSize: 14)
            let summaryAttributes: [NSAttributedString.Key: Any] = [.font: summaryFont]
            
            let totalIncome = filteredInvoices.reduce(0) { $0 + $1.amount }
            let totalExpenses = filteredExpenses.reduce(0) { $0 + $1.amount }
            let netIncome = totalIncome - totalExpenses
            
            let totalIncomeString = "Gross Income: \(currencySymbol)\(String(format: "%.2f", totalIncome))"
            let totalExpensesString = "Total Expenses: \(currencySymbol)\(String(format: "%.2f", totalExpenses))"
            let netIncomeString = "Net Income: \(currencySymbol)\(String(format: "%.2f", netIncome))"
            
            let totalIncomeAttributedString = NSAttributedString(string: totalIncomeString, attributes: summaryAttributes)
            let totalExpensesAttributedString = NSAttributedString(string: totalExpensesString, attributes: summaryAttributes)
            let netIncomeAttributedString = NSAttributedString(string: netIncomeString, attributes: summaryAttributes)
            
            totalIncomeAttributedString.draw(at: CGPoint(x: leftPadding, y: bodyYPosition))
            bodyYPosition += 20.0
            totalExpensesAttributedString.draw(at: CGPoint(x: leftPadding, y: bodyYPosition))
            bodyYPosition += 20.0
            netIncomeAttributedString.draw(at: CGPoint(x: leftPadding, y: bodyYPosition))
            
            bodyYPosition += 40.0
            
            // Draw Invoices header
            let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            let invoiceHeader = NSAttributedString(string: "Invoices", attributes: headerAttributes)
            invoiceHeader.draw(at: CGPoint(x: leftPadding, y: bodyYPosition))
            
            bodyYPosition += 24.0
            
            var totalInvoiceAmount: Double = 0.0
            
            // Draw invoices
            for invoice in invoices {
                let isPaidTextAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor: UIColor.red
                ]
                let statusString = invoice.isPaid ? "Paid" : "UNPAID"
                let statusAttributedString = NSAttributedString(string: statusString, attributes: invoice.isPaid ? nil : isPaidTextAttributes)
                
                let invoiceText = "\(invoice.student?.firstName ?? invoice.diveShop?.name ?? "Unknown"): \(currencySymbol)\(String(format: "%.2f", invoice.amount)) - Due: \(dateFormatter.string(from: invoice.dueDate)) - "
                let invoiceAttributedString = NSMutableAttributedString(string: invoiceText)
                invoiceAttributedString.append(statusAttributedString)
                
                invoiceAttributedString.draw(in: CGRect(x: leftPadding, y: bodyYPosition, width: columnWidth, height: 20.0))
                bodyYPosition += 20.0
                totalInvoiceAmount += invoice.amount
            }
            
            // Draw total for invoices
            let totalInvoiceString = "Total: \(currencySymbol)\(String(format: "%.2f", totalInvoiceAmount))"
            let totalInvoiceAttributedString = NSAttributedString(string: totalInvoiceString, attributes: headerAttributes)
            totalInvoiceAttributedString.draw(at: CGPoint(x: leftPadding, y: bodyYPosition))
            
            bodyYPosition += 40.0
            
            // Draw Expenses header
            let expenseHeader = NSAttributedString(string: "Expenses", attributes: headerAttributes)
            expenseHeader.draw(at: CGPoint(x: leftPadding, y: bodyYPosition))
            
            bodyYPosition += 24.0
            
            var totalExpenseAmount: Double = 0.0
            
            // Draw expenses
            for expense in expenses {
                let expenseString = "\(expense.expenseDescription): \(currencySymbol)\(String(format: "%.2f", expense.amount)) - Date: \(dateFormatter.string(from: expense.date))"
                let attributedString = NSAttributedString(string: expenseString)
                attributedString.draw(in: CGRect(x: leftPadding, y: bodyYPosition, width: columnWidth, height: 20.0))
                bodyYPosition += 20.0
                totalExpenseAmount += expense.amount
            }
            
            // Draw total for expenses
            let totalExpenseString = "Total: \(currencySymbol)\(String(format: "%.2f", totalExpenseAmount))"
            let totalExpenseAttributedString = NSAttributedString(string: totalExpenseString, attributes: headerAttributes)
            totalExpenseAttributedString.draw(at: CGPoint(x: leftPadding, y: bodyYPosition))
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
    
//    private func deleteExpense(at offsets: IndexSet) {
//        expenses.remove(atOffsets: offsets)
//    }
    
    
    func calculateEstimatedTaxes(for estimatedAnnualProfit: Double) -> Double {
        let taxRate = UserDefaults.standard.double(forKey: "taxRate") / 100
        print("Selected tax rate: \(taxRate)")
        return estimatedAnnualProfit * taxRate
    }
    
    func calculateCommission(for totalRevenue: Double) -> Double {
        let commissionRate = UserDefaults.standard.double(forKey: "commissionRate") / 100
        return totalRevenue * commissionRate
    }
    
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    return formatter
}()

struct FinancialView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Expense.self, configurations: config)
        
        return FinancialView()
            .modelContainer(container) // Use model container for preview
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

struct MiniTipViewStyle: TipViewStyle {
    func makeBody(configuration: TipViewStyle.Configuration) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8.0) {
                configuration.title?.font(.system(size: 12))
                configuration.message?.font(.system(size: 12))
                
            }
            .padding(5)
            
        }
        
        .frame(width: 180)
    }
}

struct HeadlineTipViewStyle: TipViewStyle {
    func makeBody(configuration: TipViewStyle.Configuration) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8.0) {
                configuration.title?.font(.system(size: 12))
                configuration.message?.font(.system(size: 12))
                
            }
            .padding(5)
            
        }
        
        .frame(width: 220)
    }
}

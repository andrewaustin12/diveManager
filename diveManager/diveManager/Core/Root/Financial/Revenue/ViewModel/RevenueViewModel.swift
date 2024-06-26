import Foundation
import SwiftUI

class RevenueViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    @Published var showingPDFPreview = false
    @Published var exportURL: URL?

    var selectedYear = Calendar.current.component(.year, from: Date())
    
    enum ExportType {
        case csv, pdf
    }

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

    func revenueForYear(_ year: Int) -> [MonthlyRevenue] {
        let calendar = Calendar.current
        var revenueByMonth: [Date: Double] = [:]

        // Initialize each month of the selected year to 0
        for month in 1...12 {
            if let monthStart = calendar.date(from: DateComponents(year: year, month: month)) {
                revenueByMonth[monthStart] = 0
            }
        }

        // Sum revenue for each month
        for invoice in invoices {
            let invoiceYear = calendar.component(.year, from: invoice.date)
            if invoiceYear == year {
                let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: invoice.date))!
                revenueByMonth[monthStart, default: 0] += invoice.amount
            }
        }

        return revenueByMonth.map { MonthlyRevenue(month: $0.key, totalRevenue: $0.value) }
                              .sorted { $0.month < $1.month }
    }

    func loadInvoices(from dataModel: DataModel) {
        self.invoices = dataModel.invoices
    }
    
    func getLastFourYearsRevenue() -> [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (0..<4).map { currentYear - $0 }
    }

    func exportRevenueData(as type: ExportType) {
        let fileName: String
        let fileURL: URL

        switch type {
        case .csv:
            let content = generateRevenueCSV()
            fileName = "revenue_data_\(selectedYear).csv"

            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                fileURL = documentDirectory.appendingPathComponent(fileName)

                do {
                    try content.write(to: fileURL, atomically: true, encoding: .utf8)
                    exportURL = fileURL
                    showingPDFPreview = true
                } catch {
                    print("Error writing file: \(error.localizedDescription)")
                }
            }

        case .pdf:
            if let pdfData = generatePDFRevenue() {
                fileName = "revenue_data_\(selectedYear).pdf"

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

    private func generateRevenueCSV() -> String {
        var csvString = "Type,Description,Amount,Date,Due Date,Status\n"

        for invoice in invoices {
            let status = invoice.isPaid ? "Paid" : "Unpaid"
            let dueDate = Formatters.dateFormatter.string(from: invoice.dueDate)
            csvString += "Invoice,\(invoice.student?.firstName ?? invoice.diveShop?.name ?? "Unknown"),\(invoice.amount),\(Formatters.dateFormatter.string(from: invoice.date)),\(dueDate),\(status)\n"
        }

        return csvString
    }

    private func generatePDFRevenue() -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Revenue Report",
            kCGPDFContextAuthor: "Dive Manager",
            kCGPDFContextTitle: "Revenue Report"
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

            // Revenue Report title
            let reportTitle = "Revenue Report"
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

            let totalRevenue = invoices
                .filter { Calendar.current.component(.year, from: $0.date) == selectedYear }
                .reduce(0) { $0 + $1.amount }
            let totalRevenueString = "Total Revenue: \(currencySymbol)\(String(format: "%.2f", totalRevenue))"
            let totalRevenueAttributedString = NSAttributedString(string: totalRevenueString, attributes: summaryAttributes)
            totalRevenueAttributedString.draw(at: CGPoint(x: leftPadding, y: yPosition))
            yPosition += 40.0

            // Draw Revenue header
            let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            let revenueHeader = NSAttributedString(string: "Revenue", attributes: headerAttributes)
            revenueHeader.draw(at: CGPoint(x: leftPadding, y: yPosition))
            yPosition += 24.0

            // Draw invoices
            for invoice in invoices.filter({ Calendar.current.component(.year, from: $0.date) == selectedYear }) {
                let invoiceText = "\(invoice.student?.firstName ?? invoice.diveShop?.name ?? "Unknown"): \(currencySymbol)\(String(format: "%.2f", invoice.amount)) - Due: \(Formatters.dateFormatter.string(from: invoice.dueDate)) - "
                let statusText = invoice.isPaid ? "Paid" : "UNPAID"

                let invoiceAttributedString = NSMutableAttributedString(string: invoiceText)
                let statusAttributes: [NSAttributedString.Key: Any] = invoice.isPaid ? [:] : [
                    .font: UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor: UIColor.red
                ]
                let statusAttributedString = NSAttributedString(string: statusText, attributes: statusAttributes)

                invoiceAttributedString.append(statusAttributedString)

                invoiceAttributedString.draw(at: CGPoint(x: leftPadding, y: yPosition))
                yPosition += 20.0
            }
        }

        return data
    }

    func formatYear(_ year: Int) -> String {
        return Formatters.formatYear(year)
    }
}


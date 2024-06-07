import Foundation

class RevenueViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []

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
}

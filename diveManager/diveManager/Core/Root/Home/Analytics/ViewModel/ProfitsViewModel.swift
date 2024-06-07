import Foundation
import Combine

struct MonthlyProfit: Identifiable {
    let id = UUID()
    let month: Date
    let totalProfit: Double
}

class ProfitViewModel: ObservableObject {
    @Published var monthlyProfits: [MonthlyProfit] = []
    
    private var cancellables: Set<AnyCancellable> = []

    init(dataModel: DataModel) {
        // Observe changes to expenses and invoices
        dataModel.$expenses
            .combineLatest(dataModel.$invoices)
            .sink { [weak self] (expenses, invoices) in
                self?.calculateProfits(expenses: expenses, invoices: invoices)
            }
            .store(in: &cancellables)
    }

    private func calculateProfits(expenses: [Expense], invoices: [Invoice]) {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!

        var profitsByMonth: [Date: Double] = [:]

        // Initialize each month of the current year to 0
        for monthOffset in 0..<12 {
            if let monthStart = calendar.date(byAdding: .month, value: monthOffset, to: startOfYear) {
                profitsByMonth[monthStart] = 0
            }
        }

        // Sum invoices for each month
        for invoice in invoices {
            if invoice.date >= startOfYear && invoice.date <= now {
                let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: invoice.date))!
                profitsByMonth[monthStart, default: 0] += invoice.amount
            }
        }

        // Subtract expenses for each month
        for expense in expenses {
            if expense.date >= startOfYear && expense.date <= now {
                let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: expense.date))!
                profitsByMonth[monthStart, default: 0] -= expense.amount
            }
        }

        self.monthlyProfits = profitsByMonth.map { MonthlyProfit(month: $0.key, totalProfit: $0.value) }
                                           .sorted { $0.month < $1.month }
    }
}

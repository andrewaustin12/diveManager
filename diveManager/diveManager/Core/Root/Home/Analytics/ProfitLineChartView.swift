import SwiftUI
import Charts
import SwiftData

struct ProfitLineChartView: View {
    @Query private var invoices: [Invoice]
    @Query private var expenses: [Expense]

    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var monthlyProfits: [MonthlyProfit] {
        let calendar = Calendar.current
        var profitData = [MonthlyProfit]()

        let currentYear = calendar.component(.year, from: Date())

        // Group invoices by month
        let groupedInvoices = Dictionary(grouping: invoices.filter {
            calendar.component(.year, from: $0.date) == currentYear
        }) { invoice in
            calendar.component(.month, from: invoice.date)
        }

        // Group expenses by month
        let groupedExpenses = Dictionary(grouping: expenses.filter {
            calendar.component(.year, from: $0.date) == currentYear
        }) { expense in
            calendar.component(.month, from: expense.date)
        }

        // Calculate monthly profits
        for month in 1...12 {
            let totalRevenue = groupedInvoices[month]?.reduce(0) { $0 + $1.amount } ?? 0
            let totalExpenses = groupedExpenses[month]?.reduce(0) { $0 + $1.amount } ?? 0
            let totalProfit = totalRevenue - totalExpenses

            let dateComponents = DateComponents(year: currentYear, month: month)
            if let date = calendar.date(from: dateComponents) {
                profitData.append(MonthlyProfit(month: date, totalProfit: totalProfit))
            }
        }

        return profitData
    }

    var body: some View {
        let totalProfit = monthlyProfits.reduce(0) { $0 + $1.totalProfit }
        let profitColor = totalProfit < 0 ? Color.red : Color.green
        let profitText = totalProfit < 0 ? "You are operating at a loss of" : "Your YTD profit is"
        let formattedProfit = String(format: "%.2f", totalProfit)

        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(profitText)
                    .foregroundStyle(.secondary)
                Text("\(currentCurrencySymbol)\(formattedProfit)")
                    .bold()
                    .foregroundColor(profitColor)
            }

            Chart(monthlyProfits) { data in
                LineMark(
                    x: .value("Month", data.month),
                    y: .value("Profit", data.totalProfit)
                )
                .foregroundStyle(profitColor.gradient)
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month(.narrow))
                }
            }
            .frame(height: 150)
        }
    }
}

struct ProfitLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Invoice.self, Expense.self, configurations: config)

        return ProfitLineChartView()
            .modelContainer(container)
    }
}


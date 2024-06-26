import SwiftUI
import SwiftData
import Charts

struct ExpensesLineChartView: View {
    @Environment(\.modelContext) private var context // SwiftData context
    @Query private var expenses: [Expense] // Query to fetch expenses from the data model

    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    // Function to calculate the expenses over the last year, grouped by month
    private func expensesOverLastYear() -> [MonthlyExpense] {
        let calendar = Calendar.current
        var expenseData = [MonthlyExpense]()

        let currentYear = calendar.component(.year, from: Date())

        // Group expenses by month
        let groupedExpenses = Dictionary(grouping: expenses.filter {
            calendar.component(.year, from: $0.date) == currentYear
        }) { expense in
            calendar.component(.month, from: expense.date)
        }

        // Calculate monthly expenses and ensure each month is represented
        for month in 1...12 {
            let totalExpenses = groupedExpenses[month]?.reduce(0) { $0 + $1.amount } ?? 0

            let dateComponents = DateComponents(year: currentYear, month: month)
            if let date = calendar.date(from: dateComponents) {
                expenseData.append(MonthlyExpense(month: date, totalExpenses: totalExpenses))
            }
        }

        return expenseData
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Your YTD expenses are")
                    .foregroundStyle(.secondary)
                Text("\(currentCurrencySymbol)\(String(format: "%.2f", expensesOverLastYear().reduce(0) { $0 + $1.totalExpenses }))")
                    .bold()
                    .foregroundStyle(.red)
            }

            Chart(expensesOverLastYear()) { data in
                AreaMark(
                    x: .value("Month", data.month, unit: .month),
                    y: .value("Total Expenses", data.totalExpenses)
                )
                .foregroundStyle(Color.red.gradient)
            }
            .frame(height: 150)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month(.narrow))
                }
            }
            .chartYAxis {
                AxisMarks() {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
        }
    }
}


#Preview {

    // Configure the model container with the mock data
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Expense.self, configurations: config)



    return ExpensesLineChartView()
        .modelContainer(container)
}

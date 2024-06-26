import SwiftUI
import Charts
import SwiftData

struct AverageExpensesChartView: View {
    @Environment(\.modelContext) private var context // Use the SwiftData model context environment
    @Query private var expenses: [Expense]
    var selectedYear: Int

    var expensesForYear: [MonthlyExpense] {
        let calendar = Calendar.current
        // Generate all months of the selected year
        let months = (1...12).map { month -> Date in
            calendar.date(from: DateComponents(year: selectedYear, month: month))!
        }
        // Group expenses by month
        let groupedExpenses = Dictionary(grouping: expenses.filter {
            calendar.component(.year, from: $0.date) == selectedYear
        }, by: { expense in
            calendar.dateComponents([.year, .month], from: expense.date)
        })
        // Map expenses to each month, filling in missing months with zero expenses
        return months.map { month in
            let dateComponents = calendar.dateComponents([.year, .month], from: month)
            let totalExpenses = groupedExpenses[dateComponents]?.reduce(0) { $0 + $1.amount } ?? 0
            return MonthlyExpense(month: month, totalExpenses: totalExpenses)
        }
    }

    var totalMonths: Int {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: DateComponents(year: selectedYear))!
        let endOfYear = selectedYear == calendar.component(.year, from: Date()) ? Date() : calendar.date(from: DateComponents(year: selectedYear, month: 12, day: 31))!
        return calendar.dateComponents([.month], from: startOfYear, to: endOfYear).month! + 1
    }

    var totalExpenses: Double {
        expensesForYear.reduce(0) { $0 + $1.totalExpenses }
    }

    var averageMonthlyExpenses: Double {
        totalExpenses / Double(totalMonths)
    }

    private var displayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let currentYear = Calendar.current.component(.year, from: Date())
        
        if selectedYear == currentYear {
            return "(thru \(formatter.string(from: Date())))"
        } else {
            return ""
        }
    }
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Expenses")
                Text("Avg Month \(currentCurrencySymbol)\(String(format: "%.f", averageMonthlyExpenses)) \(displayDateString)")
                    .bold()
                    .foregroundStyle(.secondary)
            }
            
            Chart(expensesForYear) { data in
                BarMark(
                    x: .value("Month", data.month, unit: .month),
                    y: .value("Total Expenses", data.totalExpenses)
                )
                .foregroundStyle(Color.pink.gradient)
            }
            .frame(height: 100)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month(.narrow))
                }
            }
            .chartYAxis(.automatic)
        }
    }
}

struct AverageExpensesChartView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Expense.self, configurations: config)
        
        return AverageExpensesChartView(selectedYear: 2024)
            .modelContainer(container) // Use model container for preview
    }
}


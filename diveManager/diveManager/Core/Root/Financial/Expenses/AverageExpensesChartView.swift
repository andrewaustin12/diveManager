import SwiftUI
import Charts

struct AverageExpensesChartView: View {
    @EnvironmentObject var dataModel: DataModel
    @StateObject private var expensesVM = ExpensesViewModel()
    var selectedYear: Int

    var expensesForYear: [MonthlyExpense] {
        expensesVM.expensesForYear(selectedYear)
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

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Expenses")
                Text("Avg Month $\(String(format: "%.f", averageMonthlyExpenses)) \(displayDateString)")
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
        .onAppear {
            expensesVM.loadExpenses(from: dataModel)
        }
    }
}

struct AverageExpensesChartView_Previews: PreviewProvider {
    static var previews: some View {
        AverageExpensesChartView(selectedYear: 2024)
            .environmentObject(DataModel())
    }
}

import SwiftUI
import Charts

struct FinancialBarChartView: View {
    var invoices: [Invoice]
    var expenses: [Expense]

    var body: some View {
        Chart {
            ForEach(invoices) { invoice in
                BarMark(
                    x: .value("Date", invoice.date, unit: .month),
                    y: .value("Amount", invoice.amount)
                )
                .foregroundStyle(Color.green)
            }

            ForEach(expenses) { expense in
                BarMark(
                    x: .value("Date", expense.date, unit: .month),
                    y: .value("Amount", expense.amount)
                )
                .foregroundStyle(Color.red)
            }
        }
        .chartXScale(domain: Date().addingTimeInterval(-365*24*60*60)...Date())
        .chartXAxis {
            AxisMarks(values: .stride(by: .month))
        }
        .chartYAxis {
            AxisMarks(values: .stride(by: 100)) {
                AxisGridLine()
                AxisValueLabel()
            }
        }
    }
}

#Preview {
    FinancialBarChartView(invoices: MockData.invoices, expenses: MockData.expenses)
                .frame(height: 300)
}

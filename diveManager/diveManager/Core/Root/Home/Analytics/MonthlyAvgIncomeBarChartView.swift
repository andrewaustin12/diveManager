import SwiftUI
import SwiftData
import Charts

struct MonthlyAvgIncomeBarChartView: View {
    @Environment(\.modelContext) private var context // SwiftData context
    @Query private var invoices: [Invoice] // Query to fetch invoices from the data model

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()

    private var monthlyInvoiceTotals: [String: Double] {
        var totals = [String: Double]()
        
        // Initialize totals with all months of the current year up to the current month
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        for month in 1...currentMonth {
            let monthString = String(format: "%04d-%02d", currentYear, month)
            totals[monthString] = 0
        }

        // Populate with actual invoice amounts
        for invoice in invoices {
            let year = calendar.component(.year, from: invoice.date)
            let month = calendar.component(.month, from: invoice.date)
            let monthString = String(format: "%04d-%02d", year, month)
            if year == currentYear {
                totals[monthString, default: 0] += invoice.amount
            }
        }

        return totals
    }

    private var monthlyAverage: Double {
        let totalAmount = monthlyInvoiceTotals.values.reduce(0, +)
        let currentMonth = calendar.component(.month, from: Date())
        return totalAmount / Double(currentMonth) // Divide by the current month number to get YTD monthly average
    }

    private var monthlyAverageWholeNumber: Int {
        Int(monthlyAverage)
    }

    private var sortedMonthlyTotals: [(key: String, value: Double)] {
        monthlyInvoiceTotals.sorted { $0.key < $1.key }
    }

    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Your YTD average income is")
                .foregroundStyle(.secondary)
            Text("\(currentCurrencySymbol)\(monthlyAverageWholeNumber)")
                .foregroundStyle(
                                    monthlyAverageWholeNumber > 0 ? .green :
                                    monthlyAverageWholeNumber < 0 ? .red : .gray
                                )

            Chart {
                RuleMark(y: .value("Average", monthlyAverage))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))

                ForEach(sortedMonthlyTotals, id: \.key) { (monthString, totalAmount) in
                    let components = monthString.split(separator: "-")
                    let year = Int(components[0])!
                    let month = Int(components[1])!
                    if let date = calendar.date(from: DateComponents(year: year, month: month)) {
                        BarMark(
                            x: .value("Month", date, unit: .month),
                            y: .value("Total Amount", totalAmount)
                        )
                        .foregroundStyle(Color.green.gradient)
                        .cornerRadius(6)
                    }
                }
            }
            .frame(height: 150)
            .padding(.bottom, 4)
            .chartXAxis {
                AxisMarks(format: .dateTime.month(.abbreviated))
            }
            HStack {
                Image(systemName: "line.diagonal")
                    .rotationEffect(Angle(degrees: 45))
                    .foregroundColor(.blue)

                Text("Monthly Average")
                    .foregroundStyle(.secondary)
            }
            .font(.caption2)
            .padding(.leading, 4)
            .padding(.bottom, 4)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Invoice.self, configurations: config)

    return MonthlyAvgIncomeBarChartView()
        .modelContainer(container)
}

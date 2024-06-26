import SwiftUI
import Charts
import SwiftData

struct AverageRevenueChartView: View {
    @Environment(\.modelContext) private var context // Use the SwiftData model context environment
    @Query private var invoices: [Invoice]
    var selectedYear: Int

    var revenueForYear: [MonthlyRevenue] {
        let calendar = Calendar.current
        // Generate all months of the selected year
        let months = (1...12).map { month -> Date in
            calendar.date(from: DateComponents(year: selectedYear, month: month))!
        }
        // Group invoices by month
        let groupedInvoices = Dictionary(grouping: invoices.filter {
            calendar.component(.year, from: $0.date) == selectedYear
        }, by: { invoice in
            calendar.dateComponents([.year, .month], from: invoice.date)
        })
        // Map invoices to each month, filling in missing months with zero revenue
        return months.map { month in
            let dateComponents = calendar.dateComponents([.year, .month], from: month)
            let totalRevenue = groupedInvoices[dateComponents]?.reduce(0) { $0 + $1.amount } ?? 0
            return MonthlyRevenue(month: month, totalRevenue: totalRevenue)
        }
    }

    var totalMonths: Int {
        let currentDate = Date()
        let startOfYear = Calendar.current.date(from: DateComponents(year: selectedYear))!
        if selectedYear == Calendar.current.component(.year, from: currentDate) {
            return Calendar.current.dateComponents([.month], from: startOfYear, to: currentDate).month! + 1
        } else {
            return 12
        }
    }

    var totalRevenue: Double {
        revenueForYear.reduce(0) { $0 + $1.totalRevenue }
    }

    var averageMonthlyRevenue: Double {
        totalRevenue / Double(totalMonths)
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
                Text("Revenue")
                Text("Avg Month \(currentCurrencySymbol)\(String(format: "%.f", averageMonthlyRevenue)) \(displayDateString)")
                    .bold()
                    .foregroundStyle(.secondary)
            }
            
            Chart(revenueForYear) { data in
                BarMark(
                    x: .value("Month", data.month, unit: .month),
                    y: .value("Total Revenue", data.totalRevenue)
                )
                .foregroundStyle(Color.green.gradient)
            }
            .frame(height: 200)
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

struct AverageRevenueChartView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Invoice.self, configurations: config)
        
        return AverageRevenueChartView(selectedYear: 2024)
            .modelContainer(container) // Use model container for preview
    }
}

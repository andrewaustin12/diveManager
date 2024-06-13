import SwiftUI
import Charts

struct AverageRevenueChartView: View {
    @EnvironmentObject var dataModel: DataModel
    @StateObject private var revenueVM = RevenueViewModel()
    var selectedYear: Int

    var revenueForYear: [MonthlyRevenue] {
        revenueVM.revenueForYear(selectedYear)
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
        .onAppear {
            revenueVM.loadInvoices(from: dataModel)
        }
    }
}

struct AverageRevenueChartView_Previews: PreviewProvider {
    static var previews: some View {
        AverageRevenueChartView(selectedYear: 2024)
            .environmentObject(DataModel())
    }
}

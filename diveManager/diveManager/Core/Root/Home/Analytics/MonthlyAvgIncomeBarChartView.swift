import SwiftUI
import Charts

struct MonthlyAvgIncomeBarChartView: View {
    @EnvironmentObject var dataModel: DataModel
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    private var monthlyInvoiceTotals: [DateComponents: Double] {
        let invoices = dataModel.invoices
        return Dictionary(grouping: invoices, by: { invoice in
            calendar.dateComponents([.year, .month], from: invoice.date)
        }).mapValues { invoices in
            invoices.reduce(0) { $0 + $1.amount }
        }
    }
    
    private var monthlyAverage: Double {
        let totalAmount = monthlyInvoiceTotals.values.reduce(0, +)
        return totalAmount / Double(monthlyInvoiceTotals.count)
    }
    
    private var monthlyAverageWholeNumber: Int {
        Int(monthlyAverage)
    }
    
    private var sortedMonthlyTotals: [(key: DateComponents, value: Double)] {
        monthlyInvoiceTotals.sorted {
            guard let date1 = calendar.date(from: $0.key), let date2 = calendar.date(from: $1.key) else {
                return false
            }
            return date1 < date2
        }
    }
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Your monthly average income is")
            
            Text("\(currentCurrencySymbol)\(monthlyAverageWholeNumber)")
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Chart {
                RuleMark(y: .value("Average", monthlyAverage))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                
                ForEach(sortedMonthlyTotals, id: \.key) { (dateComponents, totalAmount) in
                    if let date = calendar.date(from: dateComponents) {
                        BarMark(
                            x: .value("Month", date, unit: .month),
                            y: .value("Total Amount", totalAmount)
                        )
                        .foregroundStyle(Color.green.gradient)
                        .cornerRadius(6)
                    }
                }
            }
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

struct FinancialBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyAvgIncomeBarChartView()
            .environmentObject(DataModel())
            .frame(height: 300)
    }
}

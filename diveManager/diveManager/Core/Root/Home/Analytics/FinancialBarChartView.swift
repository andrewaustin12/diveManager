import SwiftUI
import Charts

struct FinancialBarChartView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        let invoices = dataModel.invoices
        let expenses = dataModel.expenses
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        // Aggregate invoice amounts by month
        let monthlyInvoiceTotals = Dictionary(grouping: invoices, by: { invoice in
            calendar.dateComponents([.year, .month], from: invoice.date)
        }).mapValues { invoices in
            invoices.reduce(0) { $0 + $1.amount }
        }
        
        // Calculate monthly average
        let totalAmount = monthlyInvoiceTotals.values.reduce(0, +)
        let monthlyAverage = totalAmount / Double(monthlyInvoiceTotals.count)
        let monthlyAverageWholeNumber = Int(monthlyAverage)
        
        // Convert the dictionary to an array of tuples sorted by date
        let sortedMonthlyTotals = monthlyInvoiceTotals.sorted {
            guard let date1 = calendar.date(from: $0.key), let date2 = calendar.date(from: $1.key) else {
                return false
            }
            return date1 < date2
        }
        
        return
        VStack(alignment: .leading, spacing: 4) {
            Text("Monthly Average")
            
            Text("$\(monthlyAverageWholeNumber)")
                .fontWeight(.semibold)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)
            
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
                        .cornerRadius(3)
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
        FinancialBarChartView()
            .environmentObject(DataModel())
            .frame(height: 300)
    }
}

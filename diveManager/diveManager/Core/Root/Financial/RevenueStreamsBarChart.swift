import SwiftUI
import Charts

struct RevenueStreamData: Identifiable {
    var id: RevenueStream { type }
    var type: RevenueStream
    var totalAmount: Double
}

struct RevenueStreamsBarChart: View {
    var filteredInvoices: [Invoice]
    
    var revenueData: [RevenueStreamData] {
        var revenueTotals: [RevenueStream: Double] = [:]
        
        for stream in RevenueStream.allCases {
            revenueTotals[stream] = 0.0
        }
        
        for invoice in filteredInvoices {
            for item in invoice.items {
                revenueTotals[item.category, default: 0] += item.amount
            }
        }
        
        return revenueTotals.map { RevenueStreamData(type: $0.key, totalAmount: $0.value) }
    }

    var totalRevenue: Double {
        revenueData.reduce(0) { $0 + $1.totalAmount }
    }

    var maxValue: Double {
        revenueData.map { $0.totalAmount }.max() ?? 0
    }
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Revenue Distribution")
                Text("Total: \(currentCurrencySymbol)\(totalRevenue, specifier: "%.f")")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
            }
            
            Chart(revenueData) { data in
                BarMark(
                    x: .value("Total Amount", data.totalAmount),
                    y: .value("Revenue Stream", data.type.rawValue)
                )
                .foregroundStyle(Color.teal.gradient)
                .cornerRadius(6)
                .annotation(position: .overlay, alignment: .trailing, spacing: 2) {
                                    Text("\(currentCurrencySymbol)\(data.totalAmount, specifier: "%.f")")
                                        .font(.footnote)
                                        .bold()
                                        .foregroundColor(.white)
                                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom, values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel().font(.system(size: 12, weight: .bold))
                }
            }
            .frame(height: 200)
        }
    }
}

struct RevenueStreamsBarChart_Previews: PreviewProvider {
    static var previews: some View {
        RevenueStreamsBarChart(filteredInvoices: MockData.invoices)
            .environmentObject(DataModel())
    }
}

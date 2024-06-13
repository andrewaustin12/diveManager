import SwiftUI
import Charts

struct InvoiceSummaryChartView: View {
    let invoices: [Invoice]
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var body: some View {
        VStack {
            HStack {
                Text("Total Paid Amount:")
                    .font(.headline)
                Spacer()
                Text("\(currentCurrencySymbol)\(totalPaidAmount, specifier: "%.2f")")
                    .foregroundColor(.green)
                    .bold()
            }
            HStack {
                Text("Total Unpaid Amount:")
                    .font(.headline)
                Spacer()
                Text("\(currentCurrencySymbol)\(totalUnpaidAmount, specifier: "%.2f")")
                    .foregroundColor(.red)
                    .bold()
            }
            .padding(.bottom, 10)

            if invoices.count > 0 {
                Chart {
                    BarMark(
                        x: .value("Status", "Paid"),
                        y: .value("Count", paidInvoices.count)
                    )
                    .foregroundStyle(Color.green.gradient)
                    .cornerRadius(6)
                    
                    BarMark(
                        x: .value("Status", "Unpaid"),
                        y: .value("Count", unpaidInvoices.count)
                    )
                    .foregroundStyle(Color.pink.gradient)
                    .cornerRadius(6)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                
            } else {
                ContentUnavailableView(label: {
                    Label("Not Enough Data", systemImage: "chart.xyaxis.line")
                }, description: {
                    Text("No invoices are available for this date range")
                        .padding()
                })
            }
                
            
        }
        .frame(height: 200)
    }

    private var paidInvoices: [Invoice] {
        invoices.filter { $0.isPaid }
    }

    private var unpaidInvoices: [Invoice] {
        invoices.filter { !$0.isPaid }
    }

    private var totalPaidAmount: Double {
        paidInvoices.reduce(0) { $0 + $1.amount }
    }

    private var totalUnpaidAmount: Double {
        unpaidInvoices.reduce(0) { $0 + $1.amount }
    }
}

struct InvoiceSummaryChartView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceSummaryChartView(invoices: MockData.invoices)
    }
}

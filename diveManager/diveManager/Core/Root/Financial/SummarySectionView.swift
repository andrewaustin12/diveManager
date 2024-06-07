import Charts

import SwiftUI

struct SummarySectionView: View {
    let totalIncome: Double
    let totalExpenses: Double
    let netIncome: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("Total Income:")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(totalIncome, format: .currency(code: "USD"))")
            }
            HStack {
                Text("Total Expenses:")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(totalExpenses, format: .currency(code: "USD"))")
            }
            HStack {
                Text("Net Income:")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(netIncome, format: .currency(code: "USD"))")
                    .foregroundColor(netIncome >= 0 ? .green : .pink)
                    .bold()
            }
            
            
            Chart {
                BarMark(
                    x: .value("Category", "Total Expenses"),
                    y: .value("Amount", totalExpenses)
                )
                .foregroundStyle(Color.pink.gradient)
                .cornerRadius(6)
                
                BarMark(
                    x: .value("Category", "Total Income"),
                    y: .value("Amount", totalIncome)
                )
                .foregroundStyle(Color.green.gradient)
                .cornerRadius(6)
                
                BarMark(
                    x: .value("Category", "Net Income"),
                    y: .value("Amount", netIncome)
                )
                .foregroundStyle(netIncome >= 0 ? Color.green.gradient : Color.pink.gradient)
                .cornerRadius(6)
                
                
            }
            .frame(height: 200)
        }
    }
}

struct SummarySectionView_Previews: PreviewProvider {
    static var previews: some View {
        let mockInvoices = MockData.invoices
        let mockExpenses = MockData.expenses

        let totalIncome = mockInvoices.filter { $0.isPaid }.reduce(0) { $0 + $1.amount }
        let totalExpenses = mockExpenses.reduce(0) { $0 + $1.amount }
        let netIncome = totalIncome - totalExpenses
        
        return SummarySectionView(totalIncome: totalIncome, totalExpenses: totalExpenses, netIncome: netIncome)
            .environmentObject(DataModel())
    }
}

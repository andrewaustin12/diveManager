import SwiftUI
import Charts

struct ExpensesLineChartView: View {
    @EnvironmentObject var dataModel: DataModel
    @StateObject private var expensesVM = ExpensesViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Your year to date expenses are")
                Text("$\(String(format: "%.2f", expensesVM.expensesOverLastYear().reduce(0) { $0 + $1.totalExpenses }))")
                    .bold()
                    .foregroundStyle(.red)
            }
            .padding(.bottom, 10)
            
            Chart(expensesVM.expensesOverLastYear()) { data in
                AreaMark(
                    x: .value("Month", data.month),
                    y: .value("Total Expenses", data.totalExpenses)
                )
                .foregroundStyle(Color.red.gradient)
            }
            .frame(height: 70)
            .chartXAxis(.visible)
            .chartYAxis(.automatic)
        }
        .onAppear {
            expensesVM.loadExpenses(from: dataModel)
        }
    }
}

struct ExpensesLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesLineChartView()
            .environmentObject(DataModel())
    }
}

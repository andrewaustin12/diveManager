import SwiftUI
import Charts

struct ProfitLineChartView: View {
    @EnvironmentObject var dataModel: DataModel
    @StateObject private var profitVM: ProfitViewModel
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    init(dataModel: DataModel) {
        _profitVM = StateObject(wrappedValue: ProfitViewModel(dataModel: dataModel))
    }

    var body: some View {
        let totalProfit = profitVM.monthlyProfits.reduce(0) { $0 + $1.totalProfit }
        let profitColor = totalProfit < 0 ? Color.red : Color.blue
        let profitText = totalProfit < 0 ? "You are operating with a net loss of" : "Your YTD profit is"
        let formattedProfit = String(format: "%.2f", totalProfit)

        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(profitText)
                Text("\(currentCurrencySymbol)\(formattedProfit)")
                    .bold()
                    .foregroundColor(profitColor)
            }
            
            Chart(profitVM.monthlyProfits) { data in
                LineMark(
                    x: .value("Month", data.month),
                    y: .value("Profit", data.totalProfit)
                )
                .foregroundStyle(profitColor.gradient)
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            .frame(height: 70)
        }
    }
}

struct ProfitLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        ProfitLineChartView(dataModel: DataModel())
            .environmentObject(DataModel())
    }
}

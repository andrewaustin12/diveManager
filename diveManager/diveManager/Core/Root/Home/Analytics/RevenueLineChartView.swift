//import SwiftUI
//import Charts
//
//struct RevenueLineChartView: View {
//    @EnvironmentObject var dataModel: DataModel
//    @StateObject private var revenueVM = RevenueViewModel()
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            VStack(alignment: .leading) {
//                Text("Your year to date revenue is")
////                Text("$\(String(format: "%.2f", revenueVM.revenueOverLastYear().reduce(0) { $0 + $1.totalRevenue }))")
////                    .bold()
////                    .foregroundStyle(.green)
//            }
//            .padding(.bottom, 10)
//            
//            Chart(revenueVM.revenueOverLastYear()) { data in
//                AreaMark(
//                    x: .value("Month", data.month),
//                    y: .value("Revenue", data.totalRevenue)
//                )
//                .foregroundStyle(Color.green.gradient)
//            }
//            .frame(height: 70)
//        }
//        .onAppear {
//            revenueVM.loadInvoices(from: dataModel)
//        }
//    }
//}
//
//struct RevenueLineChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        RevenueLineChartView()
//            .environmentObject(DataModel())
//    }
//}

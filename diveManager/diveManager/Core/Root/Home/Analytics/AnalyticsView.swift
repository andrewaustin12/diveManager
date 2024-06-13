import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var yearToDateRevenue: Double {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return dataModel.invoices
            .filter { calendar.component(.year, from: $0.date) == currentYear }
            .reduce(0) { $0 + $1.amount }
    }
    
    var yearToDateExpenses: Double {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return dataModel.expenses
            .filter { calendar.component(.year, from: $0.date) == currentYear }
            .reduce(0) { $0 + $1.amount }
    }
    
    var yearToDateProfit: Double {
        return yearToDateRevenue - yearToDateExpenses
    }
    
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("YTD Profit")
                            .font(.subheadline)
                        Text("\(currentCurrencySymbol)\(yearToDateProfit, specifier: "%.2f")")
                            .font(.title)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GroupBox {
                    ProfitLineChartView(dataModel: DataModel())
                }
                
//                Section(header: Text("YTD Revenue")) {
//                    RevenueLineChartView()
//                }
                
                GroupBox {
                    ExpensesLineChartView()
                }
                
                
                GroupBox {
                    MonthlyAvgIncomeBarChartView()
                }
                
                GroupBox {
                    CourseBarChartView()
                    
                }
                
                GroupBox {
                        CertificationPieChartView()
                }
            }
            .padding()
            .navigationTitle("Analytics")
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(DataModel())
}





//

//

//
//Section(header: Text("Certification Tracking")) {
//    VStack(alignment: .leading) {
//        Text("Certifications Over Time")
//            .font(.headline)
//        CertificationLineChartView(certifications: dataModel.students.flatMap { $0.certifications })
//            .frame(height: 300)
//    }
//}

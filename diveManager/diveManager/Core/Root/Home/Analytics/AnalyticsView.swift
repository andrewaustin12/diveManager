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
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("YTD Profit")) {
                    
                    VStack(alignment: .leading) {
                        
                        Text("$\(yearToDateProfit, specifier: "%.2f")")
                            .font(.title)
                        
                    }
                    
                    
                }
                
                Section(header: Text("YTD Revenue")) {
                    ProfitLineChartView(dataModel: DataModel())
                }
                
//                Section(header: Text("YTD Revenue")) {
//                    RevenueLineChartView()
//                }
                
                Section(header: Text("YTD Expenses")) {
                    ExpensesLineChartView()
                }
                
                
                Section(header: Text("Monthly Income")) {
                    FinancialBarChartView()
                }
                
                Section(header: Text("Top 5 Courses")) {
                    CourseBarChartView()
                    
                }
                
                Section(header: Text("Certifications Issued")) {
                        CertificationPieChartView()
                }
            }
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

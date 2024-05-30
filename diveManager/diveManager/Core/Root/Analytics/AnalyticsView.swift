import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var dataModel: DataModel

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Financial Analytics")) {
                    VStack(alignment: .leading) {
                        Text("Income vs Expenses")
                            .font(.headline)
                        FinancialBarChartView(invoices: dataModel.invoices, expenses: dataModel.expenses)
                            .frame(height: 300)
                    }
                }

                Section(header: Text("Student Performance")) {
                    VStack(alignment: .leading) {
                        Text("Certifications Issued")
                            .font(.headline)
                        CertificationPieChartView(certifications: dataModel.students.flatMap { $0.certifications })
                            .frame(height: 300)
                    }
                }

                Section(header: Text("Course Analytics")) {
                    VStack(alignment: .leading) {
                        Text("Course Popularity")
                            .font(.headline)
                        CourseBarChartView(courses: dataModel.courses)
                            .frame(height: 300)
                    }
                }

                Section(header: Text("Certification Tracking")) {
                    VStack(alignment: .leading) {
                        Text("Certifications Over Time")
                            .font(.headline)
                        CertificationLineChartView(certifications: dataModel.students.flatMap { $0.certifications })
                            .frame(height: 300)
                    }
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

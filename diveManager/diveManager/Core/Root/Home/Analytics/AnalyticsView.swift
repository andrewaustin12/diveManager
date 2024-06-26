import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Environment(\.modelContext) private var context // SwiftData context
    @Query private var invoices: [Invoice] // Query to fetch invoices from the data model
    @Query private var expenses: [Expense] // Query to fetch expenses from the data model

    // Calculate year-to-date revenue
    var yearToDateRevenue: Double {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return invoices
            .filter { calendar.component(.year, from: $0.date) == currentYear }
            .reduce(0) { $0 + $1.amount }
    }

    // Calculate year-to-date expenses
    var yearToDateExpenses: Double {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        return expenses
            .filter { calendar.component(.year, from: $0.date) == currentYear }
            .reduce(0) { $0 + $1.amount }
    }

    // Calculate year-to-date profit
    var yearToDateProfit: Double {
        return yearToDateRevenue - yearToDateExpenses
    }

    // Fetching the currency symbol from UserDefaults
    var currentCurrencySymbol: String {
        return UserDefaults.standard.currency.symbol
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("YTD Revenue")
                            .font(.subheadline)
                        Text("\(currentCurrencySymbol)\(yearToDateRevenue, specifier: "%.2f")")
                            .font(.title)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                GroupBox {
                    ProfitLineChartView()
                }

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

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Invoice.self, Expense.self, configurations: config)

        return AnalyticsView()
            .modelContainer(container)
    }
}

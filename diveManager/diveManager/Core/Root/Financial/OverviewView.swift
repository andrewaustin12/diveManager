import SwiftUI

enum FinancialViewSelection: String {
    case overview = "Overview"
    case expenses = "Expenses"
    case revenue = "Revenue"
}

struct OverviewView: View {
    @State private var selectedView: FinancialViewSelection = .overview
    
    var body: some View {
        NavigationStack {
            VStack {
                switch selectedView {
                case .overview:
                    FinancialView()
                case .expenses:
                    ExpensesView()
                case .revenue:
                    RevenueView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Menu {
                        Button(action: { selectedView = .overview }) {
                            Label("Overview", systemImage: "dollarsign.circle")
                        }
                        Button(action: { selectedView = .expenses }) {
                            Label("Expenses", systemImage: "list.bullet")
                        }
                        Button(action: { selectedView = .revenue }) {
                            Label("Revenue", systemImage: "chart.bar")
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Text(selectedView.rawValue)
                            Image(systemName: "chevron.down.circle")
                                .resizable()
                                .frame(width: 15, height: 15) // Adjust the size as needed
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    OverviewView()
        .environmentObject(DataModel())
}

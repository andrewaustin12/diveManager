
import Foundation

struct Expense: Identifiable {
    var id = UUID()
    var category: RevenueStream
    var date: Date
    var amount: Double
    var description: String
    
}

struct MonthlyExpense: Identifiable {
    let id = UUID()
    let month: Date
    let totalExpenses: Double
}

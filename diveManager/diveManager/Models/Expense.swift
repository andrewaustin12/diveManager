import Foundation
import SwiftData

@Model
final class Expense: Identifiable {
    var id = UUID()
    var date: Date
    var amount: Double
    var expenseDescription: String
    
    init(id: UUID = UUID(), date: Date, amount: Double, expenseDescription: String) {
        self.id = id
        self.date = date
        self.amount = amount
        self.expenseDescription = expenseDescription
    }
    
}



@Model
final class MonthlyExpense: Identifiable {
    var id: UUID
    var month: Date
    var totalExpenses: Double
    
    init(id: UUID = UUID(), month: Date, totalExpenses: Double = 0.0) {
        self.id = id
        self.month = month
        self.totalExpenses = totalExpenses
    }
}

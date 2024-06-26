import Foundation
import SwiftUI

class ExpensesViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var showingPDFPreview = false
    @Published var exportURL: URL?

    func expensesOverLastYear() -> [MonthlyExpense] {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!

        var expensesByMonth: [Date: Double] = [:]

        // Initialize each month of the last year to 0
        for monthOffset in 0..<12 {
            if let monthStart = calendar.date(byAdding: .month, value: monthOffset, to: startOfYear) {
                expensesByMonth[monthStart] = 0
            }
        }

        // Sum expenses for each month
        for expense in expenses {
            if expense.date >= startOfYear && expense.date <= now {
                let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: expense.date))!
                expensesByMonth[monthStart, default: 0] += expense.amount
            }
        }

        return expensesByMonth.map { MonthlyExpense(month: $0.key, totalExpenses: $0.value) }
                              .sorted { $0.month < $1.month }
    }
    
    func expensesForYear(_ year: Int) -> [MonthlyExpense] {
           let calendar = Calendar.current
           var expensesByMonth: [Date: Double] = [:]
           
           // Initialize each month of the selected year to 0
           for month in 1...12 {
               if let monthStart = calendar.date(from: DateComponents(year: year, month: month)) {
                   expensesByMonth[monthStart] = 0
               }
           }
           
           // Sum expenses for each month
           for expense in expenses {
               let expenseYear = calendar.component(.year, from: expense.date)
               if expenseYear == year {
                   let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: expense.date))!
                   expensesByMonth[monthStart, default: 0] += expense.amount
               }
           }

           return expensesByMonth.map { MonthlyExpense(month: $0.key, totalExpenses: $0.value) }
                                 .sorted { $0.month < $1.month }
       }

    func loadExpenses(from dataModel: DataModel) {
        self.expenses = dataModel.expenses
    }
    
    func getLastFourYearsExpenses() -> [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (0..<4).map { currentYear - $0 }
    }
    
    
}

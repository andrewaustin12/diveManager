import SwiftData
import Foundation

class GoalsViewModel: ObservableObject {
    
//    func addGoal(amount: Double, type: GoalType, category: GoalCategory, year: Int, month: Int? = nil, quarter: Int? = nil, context: ModelContext) {
//        let newGoal = Goal(amount: amount, type: type, category: category, year: year, month: month, quarter: quarter)
//        context.insert(newGoal)
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save new goal: \(error)")
//        }
//    }
    
    func goalProgress(expenses: [Expense], for goal: Goal) -> Double {
        let totalExpenses = calculateTotalExpenses(expenses: expenses, for: goal)
        return min(totalExpenses / goal.amount, 1.0)
    }
    
    func goalProgressAmount(expenses: [Expense], for goal: Goal) -> Double {
        return calculateTotalExpenses(expenses: expenses, for: goal)
    }
    
    private func calculateTotalExpenses(expenses: [Expense], for goal: Goal) -> Double {
        let calendar = Calendar.current
        var totalExpenses = 0.0
        
        switch goal.type {
        case .monthly:
            totalExpenses = expenses
                .filter { calendar.component(.year, from: $0.date) == goal.year && calendar.component(.month, from: $0.date) == goal.month }
                .reduce(0) { $0 + $1.amount }
            
        case .quarterly:
            let startMonth = (goal.quarter! - 1) * 3 + 1
            let endMonth = startMonth + 2
            totalExpenses = expenses
                .filter { calendar.component(.year, from: $0.date) == goal.year && (startMonth...endMonth).contains(calendar.component(.month, from: $0.date)) }
                .reduce(0) { $0 + $1.amount }
            
        case .yearly:
            totalExpenses = expenses
                .filter { calendar.component(.year, from: $0.date) == goal.year }
                .reduce(0) { $0 + $1.amount }
        }
        
        return totalExpenses
    }
}


import Foundation

struct Expense: Identifiable {
    var id = UUID()
    var date: Date
    var amount: Double
    var description: String
}

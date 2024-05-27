import Foundation

struct Invoice: Identifiable {
    var id = UUID()
    var student: Student
    var amount: Double
    var dueDate: Date
    var isPaid: Bool
    var school: String
}

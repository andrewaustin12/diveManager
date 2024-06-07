import Foundation

enum BillingType: String, Codable, CaseIterable {
    case student = "Student"
    case diveShop = "Dive Shop"
}

enum RevenueStream: String, CaseIterable, Codable {
    case course = "Courses"
    case sales = "Sales"
    case misc = "Misc"
}

struct Invoice: Identifiable, Codable, Hashable {
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    var student: Student?
    var diveShop: DiveShop?
    var date: Date
    var dueDate: Date
    var amount: Double
    var isPaid: Bool
    var billingType: BillingType
    var items: [InvoiceItem] = []
    var reminderDate: Date?
}

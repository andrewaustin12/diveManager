import Foundation

enum BillingType: String, Codable, CaseIterable {
    case student = "Student"
    case diveShop = "Dive Shop"
}


struct Invoice: Identifiable, Codable {
    var id = UUID()
    var student: Student?
    var diveShop: DiveShop?
    var date: Date
    var dueDate: Date
    var amount: Double
    var isPaid: Bool
    var billingType: BillingType
    var items: [InvoiceItem] = []
}

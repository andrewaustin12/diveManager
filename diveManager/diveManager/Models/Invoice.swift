import Foundation
import SwiftData

@Model
final class Invoice: Identifiable, Codable, Hashable {
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID = UUID()
    @Relationship var student: Student?
    @Relationship var diveShop: DiveShop?
    var date: Date
    var dueDate: Date
    var amount: Double
    var isPaid: Bool
    var billingType: BillingType
    var items: [InvoiceItem] = []
    var reminderDate: Date?

    init(id: UUID = UUID(), student: Student? = nil, diveShop: DiveShop? = nil, date: Date, dueDate: Date, isPaid: Bool, billingType: BillingType, amount: Double, items: [InvoiceItem], reminderDate: Date? = nil) {
        self.id = id
        self.student = student
        self.diveShop = diveShop
        self.date = date
        self.dueDate = dueDate
        self.isPaid = isPaid
        self.billingType = billingType
        self.amount = amount
        self.items = items
        self.reminderDate = reminderDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, student, diveShop, date, dueDate, amount, isPaid, billingType, items, reminderDate
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        student = try container.decodeIfPresent(Student.self, forKey: .student)
        diveShop = try container.decodeIfPresent(DiveShop.self, forKey: .diveShop)
        date = try container.decode(Date.self, forKey: .date)
        dueDate = try container.decode(Date.self, forKey: .dueDate)
        amount = try container.decode(Double.self, forKey: .amount)
        isPaid = try container.decode(Bool.self, forKey: .isPaid)
        billingType = try container.decode(BillingType.self, forKey: .billingType)
        items = try container.decode([InvoiceItem].self, forKey: .items)
        reminderDate = try container.decodeIfPresent(Date.self, forKey: .reminderDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(student, forKey: .student)
        try container.encode(diveShop, forKey: .diveShop)
        try container.encode(date, forKey: .date)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(amount, forKey: .amount)
        try container.encode(isPaid, forKey: .isPaid)
        try container.encode(billingType, forKey: .billingType)
        try container.encode(items, forKey: .items)
        try container.encode(reminderDate, forKey: .reminderDate)
    }
}

enum BillingType: String, Codable, CaseIterable {
    case student = "Student"
    case diveShop = "Dive Shop"
}

enum RevenueStream: String, CaseIterable, Codable {
    case course = "Courses"
    case dm = "DM"
    case sales = "Sales"
    case misc = "Misc"
}



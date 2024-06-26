import Foundation
import SwiftData

@Model
final class Goal: Identifiable {
    var id: UUID
    var amount: Double
    var type: GoalType
    var category: GoalCategory
    var year: Int
    var month: Int?
    var quarter: Int?
    
    init(
        id: UUID = UUID(),
        amount: Double,
        type: GoalType,
        category: GoalCategory,
        year: Int,
        month: Int? = nil,
        quarter: Int? = nil
    ) {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.year = year
        self.month = month
        self.quarter = quarter
    }
}

enum GoalType: String, CaseIterable, Identifiable, Codable {
    case monthly
    case quarterly
    case yearly
    
    var id: String { self.rawValue }
}

enum GoalCategory: String, CaseIterable, Identifiable, Codable {
    case revenue
    case sales
    case courses
    case certifications
    
    var id: String { self.rawValue }
}

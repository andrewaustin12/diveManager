import Foundation
import SwiftData

@Model
final class Session: Identifiable {
    var id: UUID
    var date: Date
    var startTime: Date
    var endTime: Date
    var location: String
    var type: SessionType
    var duration: Int
    var notes: String
    
    init(id: UUID = UUID(), date: Date, startTime: Date, endTime: Date, location: String, type: SessionType, duration: Int, notes: String) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.type = type
        self.duration = duration
        self.notes = notes
    }
}

enum SessionType: String, CaseIterable, Identifiable, Codable {
    case classroom
    case confinedWater
    case openWater
    

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .classroom:
            return "Classroom"
        case .confinedWater:
            return "Confined Water"
        case .openWater:
            return "Open Water"
        
        }
    }
}

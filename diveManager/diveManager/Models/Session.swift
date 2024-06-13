import Foundation

struct Session: Identifiable {
    var id = UUID()
    var date: Date
    var startTime: Date
    var endTime: Date
    var location: String
    var type: SessionType
    var duration: Int
    var notes: String
    var description: String
}

enum SessionType: String, CaseIterable, Identifiable {
    case confinedWater
    case openWater
    case classroom

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .confinedWater:
            return "Confined Water"
        case .openWater:
            return "Open Water"
        case .classroom:
            return "Classroom"
        }
    }
}


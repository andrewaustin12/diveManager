import Foundation

enum SessionType: String, CaseIterable, Identifiable {
    case pool = "Pool Session"
    case openWater = "Open Water Dive"
    
    var id: String { self.rawValue }
}

struct Session: Identifiable {
    var id = UUID()
    var date: Date
    var location: String
    var type: SessionType
    var duration: Int // Duration in minutes
    var notes: String
}

import Foundation

enum CourseFilter: String, CaseIterable, Identifiable {
    case upcoming = "Upcoming"
    case inProgress = "In Progress"
    case completed = "Completed"

    var id: String { self.rawValue }
}

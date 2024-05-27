import Foundation

enum CourseFilter: String, CaseIterable, Identifiable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case completed = "Completed"

    var id: String { self.rawValue }
}

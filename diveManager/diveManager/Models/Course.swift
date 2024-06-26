import Foundation
import SwiftData

@Model
final class Course: Identifiable, Hashable, Equatable {
    var id = UUID()
    @Relationship
    var students: [Student]
    var startDate: Date
    var endDate: Date
    @Relationship(deleteRule: .cascade)
    var sessions: [Session]
    var diveShop: DiveShop?
    var certificationAgency: CertificationAgency
    var selectedCourse: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), students: [Student], startDate: Date, endDate: Date, sessions: [Session], diveShop: DiveShop? = nil, certificationAgency: CertificationAgency, selectedCourse: String, isCompleted: Bool) {
        self.id = id
        self.students = students
        self.startDate = startDate
        self.endDate = endDate
        self.sessions = sessions
        self.diveShop = diveShop
        self.certificationAgency = certificationAgency
        self.selectedCourse = selectedCourse
        self.isCompleted = isCompleted
    }

    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

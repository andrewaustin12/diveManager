import Foundation
import SwiftData

@Model
final class EmailList: Identifiable {
    var id = UUID()
    var name: String
    var students: [Student]
    
    init(id: UUID = UUID(), name: String, students: [Student]) {
        self.id = id
        self.name = name
        self.students = students
    }
}

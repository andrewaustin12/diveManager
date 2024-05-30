import Foundation

struct Student: Identifiable, Codable, Hashable, Equatable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var studentID: String
    var email: String
    var certifications: [Certification] =  []
}

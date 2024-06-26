import Foundation
import SwiftData

@Model
final class Student: Identifiable, Codable, Hashable, Equatable {
    var id = UUID()
    var firstName: String = ""
    var lastName: String = ""
    var studentID: String = ""
    var email: String = ""
    
    @Relationship(deleteRule: .cascade)
    var certifications: [Certification] = []
    
    init(id: UUID = UUID(), firstName: String, lastName: String, studentID: String, email: String, certifications: [Certification]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.studentID = studentID
        self.email = email
        self.certifications = certifications
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        studentID = try container.decode(String.self, forKey: .studentID)
        email = try container.decode(String.self, forKey: .email)
        certifications = try container.decode([Certification].self, forKey: .certifications)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, studentID, email, certifications
    }
}

extension Student {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(studentID, forKey: .studentID)
        try container.encode(email, forKey: .email)
        try container.encode(certifications, forKey: .certifications)
    }
}

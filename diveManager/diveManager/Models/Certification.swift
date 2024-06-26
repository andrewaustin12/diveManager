import Foundation
import SwiftData

@Model
final class Certification: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var dateIssued: Date
    var agency: CertificationAgency
    
    var student: Student?
    
    init(id: UUID = UUID(), name: String, dateIssued: Date, agency: CertificationAgency) {
        self.id = id
        self.name = name
        self.dateIssued = dateIssued
        self.agency = agency
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        dateIssued = try container.decode(Date.self, forKey: .dateIssued)
        agency = try container.decode(CertificationAgency.self, forKey: .agency)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, dateIssued, agency
    }
}

extension Certification {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(dateIssued, forKey: .dateIssued)
        try container.encode(agency, forKey: .agency)
    }
}

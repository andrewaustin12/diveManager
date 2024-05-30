import Foundation

struct Certification: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var dateIssued: Date
    var agency: CertificationAgency
}

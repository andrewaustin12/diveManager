import Foundation

struct Certification: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dateIssued: Date
    var agency: CertificationAgency
}

import Foundation
import SwiftData

@Model
final class DiveShop: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var address: String
    var phone: String
    var email: String
    
    init(id: UUID = UUID(), name: String, address: String, phone: String, email: String) {
        self.id = id
        self.name = name
        self.address = address
        self.phone = phone
        self.email = email
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
    }
    
    private enum CodingKeys: String, CodingKey {
           case id, name, address, phone, email
       }
}

extension DiveShop {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(phone, forKey: .phone)
        try container.encode(email, forKey: .email)
    }
}

import Foundation
import SwiftData

@Model
class User {
    var id: UUID
    var username: String
    var email: String
    var password: String // For demonstration; use secure storage in a real app

    init(username: String, email: String, password: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.password = password
    }
}

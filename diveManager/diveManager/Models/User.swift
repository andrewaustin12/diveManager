import Foundation
import SwiftData


class User {
    var id: UUID
    var username: String
    var email: String
    var password: String
    

    init(username: String, email: String, password: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.password = password
    }
}

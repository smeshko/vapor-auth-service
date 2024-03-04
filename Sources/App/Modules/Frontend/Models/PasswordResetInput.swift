import Vapor

struct PasswordResetInput: Codable {
    enum CodingKeys: String, CodingKey {
        case password
        case confirmPassword = "confirm_password"
    }
    let password: String
    let confirmPassword: String
}

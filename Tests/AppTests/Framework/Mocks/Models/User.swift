@testable import App
import Vapor

extension UserAccountModel {
    static func mock(
        app: Application,
        email: String = "test@test.com",
        firstName: String? = "John",
        lastName: String? = "Doe",
        isAdmin: Bool = false,
        isEmailVerified: Bool = true
    ) throws -> UserAccountModel {
        try UserAccountModel(
            email: email,
            password: app.password.hash("password"),
            firstName: firstName,
            lastName: lastName,
            isAdmin: isAdmin,
            isEmailVerified: isEmailVerified
        )
    }
}

import Vapor
import Entities
import JWT

private let accessTokenLifetime: Double = 15.minutes

extension Payload: Authenticatable {
    init(with user: UserAccountModel) throws {
        self.init(
            userID: try user.requireID(),
            fullName: user.fullName,
            email: user.email,
            isAdmin: user.isAdmin,
            expiresAt: Date().addingTimeInterval(accessTokenLifetime)
        )
    }
}

import Entities
import Vapor

extension Auth.TokenRefresh.Response: Content {
    init(
        token: String,
        user: UserAccountModel,
        on req: Request
    ) throws {
        self.init(
            refreshToken: token,
            accessToken: try req.jwt.sign(Payload(with: user))
        )
    }
}

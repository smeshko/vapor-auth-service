import Entities
import Vapor

struct AuthRouter: RouteCollection {
    let controller = AuthController()
    
    func boot(routes: RoutesBuilder) throws {
        let api = routes
            .grouped("api")
            .grouped("auth")
        
        api
            .grouped(UserCredentialsAuthenticator())
            .post("sign-in", use: controller.signIn)
        
        api.post("sign-up", use: controller.signUp)
        
        api.post("refresh", use: controller.refreshAccessToken)
        api.post("reset-password", use: controller.resetPassword)
        
        api
            .grouped(UserAccountModel.guardMiddleware(throwing: AuthenticationError.userNotFound))
            .post("logout", use: controller.logout)
    }
}

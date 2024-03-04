import Vapor

struct FrontendRouter: RouteCollection {
    
    let controller = FrontendController()
    
    func boot(routes: RoutesBuilder) throws {

        routes.get("verify-email", use: controller.verifyEmail)
        routes.get("reset-password", use: controller.resetPassword)
        routes.post("reset-password", use: controller.resetPasswordAction)
    }
}

import Vapor

struct UserRouter: RouteCollection {
    
    let controller = UserController()
    
    func boot(routes: RoutesBuilder) throws {
        let api = routes
            .grouped("api")
            .grouped("user")
        
        let protectedAPI = api
            .grouped(UserPayloadAuthenticator())
        
        protectedAPI.delete("delete", use: controller.delete)
        protectedAPI.get("me", use: controller.getCurrentUser)
        protectedAPI.patch("update", use: controller.patch)

        protectedAPI
            .grouped(EnsureAdminUserMiddleware())
            .get("list", use: controller.list)
    }
}

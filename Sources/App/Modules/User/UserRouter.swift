import Vapor
import Entities

struct UserRouter: RouteCollection {
    
    let userController = UserController()
    let deviceController = DeviceController()
    
    func boot(routes: RoutesBuilder) throws {
        user(routes: routes)
        device(routes: routes)
    }
}

private extension UserRouter {
    func user(routes: RoutesBuilder) {
        let api = routes
            .grouped("api")
            .grouped("user")
        
        let protectedAPI = api
            .grouped(UserAccountModel.guard())

        protectedAPI.delete("delete", use: userController.delete)
        protectedAPI.get("me", use: userController.getCurrentUser)
        protectedAPI.patch("update", use: userController.patch)
        
        protectedAPI.post("follow", ":userID", use: userController.follow)
        protectedAPI.post("unfollow", ":userID", use: userController.unfollow)

        protectedAPI
            .grouped(EnsureAdminUserMiddleware())
            .get("list", use: userController.list)
    }
    
    func device(routes: RoutesBuilder) {
        let api = routes
            .grouped("api")
            .grouped("device")
            .grouped(UserAccountModel.guard())
        
        api
            .post("create", use: deviceController.create)

        api
            .patch("update", ":deviceID", use: deviceController.patch)
    }
}

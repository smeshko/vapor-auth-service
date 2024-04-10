import Entities
import Vapor

struct MediaRouter: RouteCollection {
    let controller = MediaController()
    
    func boot(routes: any RoutesBuilder) throws {
        let mediaAPI = routes
            .grouped("api")
            .grouped("media")
        
        mediaAPI.get("download", ":mediaID", use: controller.download)

        let protectedAPI = mediaAPI
            .grouped(UserAccountModel.guardMiddleware(throwing: AuthenticationError.userNotFound))

        protectedAPI.on(
            .POST, "upload",
            body: .collect(maxSize: 10_000_000),
            use: controller.upload
        )
    }
}

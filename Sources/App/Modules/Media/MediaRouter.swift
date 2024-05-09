import Entities
import Vapor

struct MediaRouter: RouteCollection {
    let controller = MediaController()
    
    func boot(routes: any RoutesBuilder) throws {
        let mediaAPI = routes
            .grouped("api")
            .grouped("media")
        
        mediaAPI
            .post("download", use: controller.download)

        let protectedAPI = mediaAPI
            .grouped(UserAccountModel.guard())

        protectedAPI.on(
            .POST, "upload",
            body: .collect,
            use: controller.upload
        )
    }
}

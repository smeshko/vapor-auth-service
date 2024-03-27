import Vapor

struct MediaRouter: RouteCollection {
    let controller = MediaController()
    
    func boot(routes: any RoutesBuilder) throws {
        let mediaAPI = routes
            .grouped("api")
            .grouped("media")
        
        let protectedAPI = mediaAPI
            .grouped(UserPayloadAuthenticator())
        
        protectedAPI.on(
            .POST, "upload",
            body: .collect(maxSize: 10_000_000),
            use: controller.upload
        )

        mediaAPI.get("download", ":mediaID", use: controller.download)
    }
}

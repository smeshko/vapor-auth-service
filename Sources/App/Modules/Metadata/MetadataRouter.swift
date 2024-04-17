import Vapor

struct MetadataRouter: RouteCollection {
    
    let controller = MetadataController()
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: controller.routes)
        
        let apiRoute = routes
            .grouped("api")
            .grouped("metadata")
        
        apiRoute.post("", use: controller.metadata)
        apiRoute.get("challenge", use: controller.challenge)
    }
}

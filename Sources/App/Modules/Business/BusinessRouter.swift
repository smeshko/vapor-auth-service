import Vapor

struct BusinessRouter: RouteCollection {
    let controller = BusinessController()
    
    func boot(routes: any RoutesBuilder) throws {
        let api = routes
            .grouped("api")
            .grouped("business")
            
        api.post("sign-up", use: controller.create)
    }
}

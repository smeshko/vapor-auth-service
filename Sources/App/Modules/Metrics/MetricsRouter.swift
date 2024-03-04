import Vapor

struct MetricsRouter: RouteCollection {
    
    let controller = MetricsController()
    
    func boot(routes: RoutesBuilder) throws {
        routes.get("metrics", use: controller.metrics)
    }
}

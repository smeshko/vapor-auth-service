import Entities
import Vapor

struct ExternalServicesRouter: RouteCollection {
    
    let placesController = PlacesController()
    let notificationsController = NotificationsController()
    
    func boot(routes: any RoutesBuilder) throws {
        let api = routes
            .grouped("api")
            .grouped("services")
        
        places(routes: api)
        notifications(routes: api)
    }
}

private extension ExternalServicesRouter {
    func places(routes: any RoutesBuilder) {
        let api = routes
            .grouped("places")
        
        api.get("autocomplete", use: placesController.autocomplete)
        api.get("search", use: placesController.nearby)
        api.get("geocode", use: placesController.geocode)
        api.get("reverse-geocode", use: placesController.reverseGeocode)
    }
    
    func notifications(routes: any RoutesBuilder) {
        let api = routes
            .grouped("notifications")
        
        api
            .grouped(EnsureAdminUserMiddleware())
            .post("test-notification", ":deviceID", use: notificationsController.sendTestPush)
    }
}

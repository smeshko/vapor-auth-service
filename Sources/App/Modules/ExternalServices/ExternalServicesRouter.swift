import Entities
import Vapor

struct ExternalServicesRouter: RouteCollection {
    
    let places = PlacesController()
    
    func boot(routes: any RoutesBuilder) throws {
        let api = routes
            .grouped("api")
            .grouped("services")
        
        let placesAPI = api.grouped("places")
        placesAPI.get("autocomplete", use: places.autocomplete)
        placesAPI.get("search", use: places.nearby)
        placesAPI.get("geocode", use: places.geocode)
        placesAPI.get("reverse-geocode", use: places.reverseGeocode)
    }
}

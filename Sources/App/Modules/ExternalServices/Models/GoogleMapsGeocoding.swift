import Entities
import Vapor

extension Places.Geocode.Response: Content {}

struct GoogleMapsGeocodingResponse: Content {
    struct Result: Content {
        struct Geometry: Content {
            struct Location: Content {
                let lat: Double
                let lng: Double
            }
            let location: Location
        }
        let formattedAddress: String
        let geometry: Geometry
        let placeId: String
    }
    
    let results: [Result]
    let status: String
}

extension Places.Geocode.Response {
    init(remote: GoogleMapsGeocodingResponse.Result) {
        self.init(
            placeId: remote.placeId,
            address: remote.formattedAddress,
            lat: remote.geometry.location.lat,
            lon: remote.geometry.location.lng
        )
    }
}

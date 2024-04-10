import Vapor
import Entities

extension Places.Search.Response: Content {}

struct GooglePlacesRequest: Content {
    enum IncludedType: String, Content {
        case restaurant
    }
    struct Restriction: Content {
        struct Circle: Content {
            struct Center: Content {
                let latitude: Double
                let longitude: Double
            }
            let center: Center
            let radius: Double
        }
        let circle: Circle
    }
    let includedTypes: [IncludedType]
    let maxResultCount: Int
    let locationRestriction: Restriction
    
    static var mask: String {
        "places.displayName.text,places.formattedAddress,places.location,places.id"
    }
    
    init(
        includedTypes: [IncludedType] = [.restaurant],
        maxResultCount: Int = 10,
        latitude: Double,
        longitude: Double,
        radius: Double = 500.0
    ) {
        self.includedTypes = includedTypes
        self.maxResultCount = maxResultCount
        self.locationRestriction = .init(
            circle: .init(
                center: .init(
                    latitude: latitude,
                    longitude: longitude
                ),
                radius: radius
            )
        )
    }
}

struct GooglePlacesResponse: Content {
    struct Place: Content {
        struct Location: Content {
            let latitude: Double
            let longitude: Double
        }
        
        struct Name: Content {
            let text: String
        }
        
        let id: String
        let formattedAddress: String
        let location: Location
        let displayName: Name
        
        var name: String {
            displayName.text
        }
    }
    let places: [Place]
}

extension Places.Search.Response {
    init(remote: GooglePlacesResponse) {
        self.init(
            places: remote.places.map(Places.Place.init(remote:))
        )
    }
}

extension Places.Place {
    init(remote: GooglePlacesResponse.Place) {
        self.init(
            name: remote.name,
            address: remote.formattedAddress,
            latitude: remote.location.latitude,
            longitude: remote.location.longitude
        )
    }
}

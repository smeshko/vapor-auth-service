import Entities
import Vapor

struct PlacesController {
    
    func nearby(_ req: Request) async throws -> Places.Search.Response {
        let lat = try req.query.get(Double.self, at: "latitude")
        let lon = try req.query.get(Double.self, at: "longitude")
        let type = try req.query.get(String?.self, at: "type")

        let response = try await req.client.post(
            .init(string: "https://places.googleapis.com/v1/places:searchNearby"),
            headers: .init(
                [
                    ("Content-Type", "application/json"),
                    ("X-Goog-Api-Key", Environment.placesKey),
                    ("X-Goog-FieldMask", GooglePlacesSearchRequest.mask)
                ]
            ),
            content: GooglePlacesSearchRequest(
                includedTypes: [GooglePlacesIncludedType(rawValue: type ?? "") ?? .restaurant],
                latitude: lat,
                longitude: lon
            )
        )
        
        do {
            let places = try response.content.decode(GooglePlacesSearchResponse.self)
            return .init(remote: places)
        } catch {
            return .init(places: [])
        }
    }
    
    func autocomplete(_ req: Request) async throws -> Places.Autocomplete.Response {
        let query = try req.query.get(String.self, at: "query")
        
        var locationBias: GooglePlacesAutocompleteRequest.Bias? = nil
        
        if let lat = try req.query.get(Double?.self, at: "lat"),
           let lon = try req.query.get(Double?.self, at: "lon") {
            locationBias = .init(lon: lon, lat: lat)
        }
        
        let response = try await req.client.post(
            .init(string: "https://places.googleapis.com/v1/places:autocomplete"),
            headers: .init(
                [
                    ("Content-Type", "application/json"),
                    ("X-Goog-Api-Key", Environment.placesKey)
                ]
            ),
            content: GooglePlacesAutocompleteRequest(input: query, locationBias: locationBias)
        )
        
        do {
            let places = try response.content.decode(GooglePlacesAutocompleteResponse.self)
            return .init(remote: places)
        } catch {
            return .init(suggestions: [])
        }
    }
    
    func geocode(_ req: Request) async throws -> Places.Geocode.Response {
        let placeId = try req.query.get(String.self, at: "placeId")
        
        let response = try await req.client.get(
            .init(string: "https://maps.googleapis.com/maps/api/geocode/json?place_id=\(placeId)&key=\(Environment.placesKey)")
        )
        
        let geocodingResult = try response.content.decode(
            GoogleMapsGeocodingResponse.self,
            using: JSONDecoder().keyStrategy(.convertFromSnakeCase)
        )
        
        guard let first = geocodingResult.results.first else {
            throw ContentError.geocodingReturnedNoResults
        }
        
        return .init(remote: first)
    }

    func reverseGeocode(_ req: Request) async throws -> [Places.Geocode.Response] {
        let lat = try req.query.get(Double.self, at: "latitude")
        let lon = try req.query.get(Double.self, at: "longitude")

        let response = try await req.client.get(
            .init(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lon)&result_type=street_address&key=\(Environment.placesKey)")
        )
        
        let geocodingResult = try response.content.decode(
            GoogleMapsGeocodingResponse.self,
            using: JSONDecoder().keyStrategy(.convertFromSnakeCase)
        )
        
        return geocodingResult.results.map(Places.Geocode.Response.init(remote:))
    }
}

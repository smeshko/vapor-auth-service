import Entities
import Vapor

struct PlacesController {
    
    func nearby(_ req: Request) async throws -> Places.Search.Response {
        let lat = try req.query.get(Double.self, at: "latitude")
        let lon = try req.query.get(Double.self, at: "longitude")

        let response = try await req.client.post(
            .init(string: "https://places.googleapis.com/v1/places:searchNearby"),
            headers: .init(
                [
                    ("Content-Type", "application/json"),
                    ("X-Goog-Api-Key", Environment.placesKey),
                    ("X-Goog-FieldMask", GooglePlacesSearchRequest.mask)
                ]
            ),
            content: GooglePlacesSearchRequest(latitude: lat, longitude: lon)
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

        let response = try await req.client.post(
            .init(string: "https://places.googleapis.com/v1/places:autocomplete"),
            headers: .init(
                [
                    ("Content-Type", "application/json"),
                    ("X-Goog-Api-Key", Environment.placesKey)
                ]
            ),
            content: GooglePlacesAutocompleteRequest(input: query)
        )
        
        do {
            let places = try response.content.decode(GooglePlacesAutocompleteResponse.self)
            return .init(remote: places)
        } catch {
            return .init(suggestions: [])
        }

    }
}

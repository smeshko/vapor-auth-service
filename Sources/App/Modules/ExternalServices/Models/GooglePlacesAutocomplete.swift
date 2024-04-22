import Entities
import Vapor

extension Places.Autocomplete.Response: Content {}

struct GooglePlacesAutocompleteRequest: Content {
    struct Bias: Content {
        struct Circle: Content {
            struct Center: Content {
                let latitude: Double
                let longitude: Double
            }
            let center: Center
            let radius: Double
        }
        let circle: Circle
        
        init(
            lon: Double,
            lat: Double,
            radius: Double = 500
        ) {
            self.circle = .init(
                center: .init(latitude: lat, longitude: lon),
                radius: radius
            )
        }
    }

    let input: String
    let includedPrimaryTypes: [GooglePlacesIncludedType]
    let includedRegionCodes: [String]
    let locationBias: Bias?
    
    init(
        input: String,
        includedPrimaryTypes: [GooglePlacesIncludedType] = [.address, .geocode],
        includedRegionCodes: [String] = ["us", "bg"],
        locationBias: Bias? = nil
    ) {
        self.input = input
        self.includedPrimaryTypes = includedPrimaryTypes
        self.includedRegionCodes = includedRegionCodes
        self.locationBias = locationBias
    }
}

struct GooglePlacesAutocompleteResponse: Content {
    struct Suggestion: Content {
        struct Prediction: Content {
            struct StructuredFormat: Content {
                struct Text: Content {
                    let text: String
                }
                let mainText: Text
                let secondaryText: Text
            }
            
            let placeId: String
            let structuredFormat: StructuredFormat
        }
        let placePrediction: Prediction
    }
    
    let suggestions: [Suggestion]
    
    init(suggestions: [Suggestion]) {
        self.suggestions = suggestions
    }
}

extension Places.Autocomplete.Response {
    init(remote: GooglePlacesAutocompleteResponse) {
        self.init(suggestions: remote.suggestions.map(Places.Autocomplete.Response.Suggestion.init(remote:)))
    }
}

extension Places.Autocomplete.Response.Suggestion {
    init(remote: GooglePlacesAutocompleteResponse.Suggestion) {
        self.init(
            placeId: remote.placePrediction.placeId,
            mainText: remote.placePrediction.structuredFormat.mainText.text,
            secondaryText: remote.placePrediction.structuredFormat.secondaryText.text
        )
    }
}

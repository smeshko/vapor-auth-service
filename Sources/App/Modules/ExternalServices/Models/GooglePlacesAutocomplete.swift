import Entities
import Vapor

extension Places.Autocomplete.Response: Content {}

struct GooglePlacesAutocompleteRequest: Content {
    let input: String
    let includedPrimaryTypes: [GooglePlacesIncludedType]
    let includedRegionCodes: [String]
    
    init(
        input: String,
        includedPrimaryTypes: [GooglePlacesIncludedType] = [.address, .geocode],
        includedRegionCodes: [String] = ["us", "bg"]
    ) {
        self.input = input
        self.includedPrimaryTypes = includedPrimaryTypes
        self.includedRegionCodes = includedRegionCodes
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
}

extension Places.Autocomplete.Response {
    init(remote: GooglePlacesAutocompleteResponse) {
        self.init(suggestions: remote.suggestions.map(Places.Autocomplete.Response.Suggestion.init(remote:)))
    }
}

extension Places.Autocomplete.Response.Suggestion {
    init(remote: GooglePlacesAutocompleteResponse.Suggestion) {
        self.init(
            mainText: remote.placePrediction.structuredFormat.mainText.text,
            secondaryText: remote.placePrediction.structuredFormat.secondaryText.text
        )
    }
}

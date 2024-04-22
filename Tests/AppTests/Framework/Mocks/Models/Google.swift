@testable import App

extension GooglePlacesSearchResponse {
    static func mock() -> GooglePlacesSearchResponse {
        .init(
            places: [
                .init(
                    id: "1",
                    formattedAddress: "Address",
                    location: .init(latitude: 5, longitude: 10),
                    displayName: .init(text: "d")
                )
            ]
        )
    }
}

extension GooglePlacesAutocompleteResponse {
    static func mock() -> GooglePlacesAutocompleteResponse {
        .init(
            suggestions: [
                .init(
                    placePrediction: .init(
                        placeId: "1",
                        structuredFormat: .init(
                            mainText: .init(text: "m"),
                            secondaryText: .init(text: "s")
                        )
                    )
                )
            ]
        )
    }
}

extension GoogleMapsGeocodingResponse {
    static func mock() -> GoogleMapsGeocodingResponse {
        .init(
            results: [
                .init(
                    formattedAddress: "Address",
                    geometry: .init(
                        location: .init(lat: 5, lng: 10)
                    ),
                    placeId: "1"
                )
            ],
            status: "ok"
        )
    }
}

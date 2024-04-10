import Entities
import Foundation
import Vapor

struct MetadataController {
    func routes(_ req: Request) async throws -> [String] {
        req.application.routes.all.map(\.pretty)
    }
    
    func metadata(_ req: Request) async throws -> Metadata.Response {
        let request = try req.content.decode(Metadata.Request.self)
        
        guard let token = try await req.repositories.challengeTokens.find(value: request.attestation.challenge),
              let challengeData = Data(base64Encoded: token.value) else {
            throw ContentError.contentNotFound
        }

        try req.appAttest.verify(
            attestation: request.attestation.attestation,
            challenge: challengeData,
            keyID: request.attestation.keyID,
            teamID: request.attestation.teamID,
            bundleID: request.attestation.bundleID
        )
        
        try await req.repositories.challengeTokens.delete(id: token.requireID())
        
        return .init(key: Environment.jwtKey)
    }
    
    func challenge(_ req: Request) async throws -> Attestation.Challenge.Response {
        let model = ChallengeTokenModel(value: req.random.generate(bits: 32 * 8))
        try await req.repositories.challengeTokens.create(model)
        
        return .init(value: model.value)
    }

    func nearby(_ req: Request) async throws -> Places.Search.Response {
        let lat = try req.query.get(Double.self, at: "latitude")
        let lon = try req.query.get(Double.self, at: "longitude")
        
        let response = try await req.client.post(
            .init(string: "https://places.googleapis.com/v1/places:searchNearby"),
            headers: .init(
                [
                    ("Content-Type", "application/json"),
                    ("X-Goog-Api-Key", Environment.placesKey),
                    ("X-Goog-FieldMask", GooglePlacesRequest.mask)
                ]
            ),
            content: GooglePlacesRequest(latitude: lat, longitude: lon)
        )
        
        let places = try response.content.decode(GooglePlacesResponse.self)
        
        return .init(remote: places)
    }
}

extension Route {
    var pretty: String {
        "\(method.rawValue) \(path.map(\.description).joined(separator: "/"))"
    }
}

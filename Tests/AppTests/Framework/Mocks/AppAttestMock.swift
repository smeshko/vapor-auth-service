@testable import App
import Vapor

extension Application.AppAttests.Provider {
    static var fake: Self {
        .init {
            $0.appAttests.use { _ in AppAttestMock() }
        }
    }
}

struct AppAttestMock: AttestationService {
    func verify(
        attestation: Data,
        challenge: Data,
        keyID: Data,
        teamID: String,
        bundleID: String
    ) throws {
        if attestation.isEmpty || challenge.isEmpty ||
            keyID.isEmpty || teamID.isEmpty || bundleID.isEmpty {
            throw Abort(.badRequest)
        }
    }
}

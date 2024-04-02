import AppAttest
import Vapor

extension Application.AppAttests.Provider {
    static var appAttest: Self {
        .init {
            $0.appAttests.use { _ in RealAppAttest() }
        }
    }
}

struct RealAppAttest: AttestationService {
    func verify(
        attestation: Data,
        challenge: Data,
        keyID: Data,
        teamID: String,
        bundleID: String
    ) throws {
        _ = try AppAttest.verifyAttestation(
            challenge: challenge,
            request: .init(
                attestation: attestation,
                keyID: keyID
            ),
            appID: .init(
                teamID: teamID,
                bundleID: bundleID
            )
        )
    }
}

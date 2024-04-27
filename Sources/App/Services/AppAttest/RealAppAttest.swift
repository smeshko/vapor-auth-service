import AppAttest
import Vapor

extension Application.Service.Provider where ServiceType == AttestationService {
    static var live: Self {
        .init {
            $0.services.appAttest.use { _ in RealAppAttest() }
        }
    }
}

struct RealAppAttest: AttestationService {
    
    func `for`(_ request: Request) -> any AttestationService {
        Self.init()
    }
    
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

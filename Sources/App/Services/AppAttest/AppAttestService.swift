import Vapor

public protocol AttestationService {
    func `for`(_ request: Request) -> AttestationService

    func verify(
        attestation: Data,
        challenge: Data,
        keyID: Data,
        teamID: String,
        bundleID: String
    ) throws
}

extension Application.Services {
    var appAttest: Application.Service<AttestationService> {
        .init(application: application)
    }
}

extension Request.Services {
    var appAttest: AttestationService {
        self.request.application.services.appAttest.service.for(request)
    }
}

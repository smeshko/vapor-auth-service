import Vapor

extension Application {
    public var appAttest: AppAttest {
        .init(app: self)
    }
    
    public struct AppAttest: AttestationService {
        let app: Application
        
        var appAttest: AttestationService {
            guard let makeAppAttest = app.appAttests.storage.makeAppAttest else {
                fatalError("appAttests not configured, please use: app.appAttests.use")
            }
            
            return makeAppAttest(app)
        }
        
        public func verify(
            attestation: Data,
            challenge: Data,
            keyID: Data,
            teamID: String,
            bundleID: String
        ) throws {
            try appAttest.verify(
                attestation: attestation,
                challenge: challenge,
                keyID: keyID,
                teamID: teamID,
                bundleID: bundleID
            )
        }
    }
}

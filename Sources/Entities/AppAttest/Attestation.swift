import Foundation

public enum Attestation {
    public enum Challenge {
        public struct Response: Codable {
            public let value: String
            
            public init(value: String) {
                self.value = value
            }
        }
    }
    
    public enum Verification {
        public struct Request: Codable {
            public let attestation: Data
            public let challenge: String
            public let keyID: Data
            public let teamID: String
            public let bundleID: String
            
            public init(
                attestation: Data,
                challenge: String,
                keyID: Data,
                teamID: String,
                bundleID: String
            ) {
                self.attestation = attestation
                self.challenge = challenge
                self.keyID = keyID
                self.teamID = teamID
                self.bundleID = bundleID
            }
        }
    }
}

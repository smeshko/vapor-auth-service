import Foundation
import JWTKit

private let accessTokenLifetime: Double = 15 * 60

public struct Payload: JWTPayload, Codable, Equatable, Sendable {
    public let userID: UUID
    public let fullName: String
    public let email: String
    public let isAdmin: Bool
    public let expiresAt: Date
    
    public init(
        userID: UUID,
        fullName: String,
        email: String,
        isAdmin: Bool,
        expiresAt: Date
    ) {
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.isAdmin = isAdmin
        self.expiresAt = expiresAt
    }
    
    public func verify(using signer: JWTSigner) throws {
        let claim = ExpirationClaim(value: expiresAt)
        try claim.verifyNotExpired()
    }
}

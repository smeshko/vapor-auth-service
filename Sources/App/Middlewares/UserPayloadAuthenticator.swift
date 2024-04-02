import Vapor
import JWT
import Entities

struct UserPayloadAuthenticator: AsyncJWTAuthenticator {
    typealias Payload = Entities.Payload
    
    func authenticate(jwt: Payload, for request: Request) async throws {
        do {
            let payload = try request.jwt.verify(as: Payload.self)
            guard let user = try await request.repositories.users.find(id: payload.userID) else {
                throw AuthenticationError.userNotFound
            }

            request.auth.login(user)
        } catch {
            throw AuthenticationError.accessTokenHasExpired
        }
    }
}

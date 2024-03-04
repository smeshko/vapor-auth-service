import Entities
import Vapor

struct EnsureAdminUserMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let payload = try request.jwt.verify(as: Payload.self)

        guard payload.isAdmin else {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}

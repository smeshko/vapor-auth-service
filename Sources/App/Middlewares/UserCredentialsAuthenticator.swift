import Vapor
import Fluent
import Entities

extension Auth.Login.Request: Content {}

struct UserCredentialsAuthenticator: AsyncCredentialsAuthenticator {
    
    func authenticate(
        credentials: Auth.Login.Request,
        for req: Request
    ) async throws {
        try Auth.Login.Request.validate(content: req)
        let loginRequest = try req.content.decode(Auth.Login.Request.self)
        
        guard let user = try await req.repositories.users.find(email: loginRequest.email) else {
            throw AuthenticationError.invalidEmailOrPassword
        }
        
        guard user.isEmailVerified else {
            throw AuthenticationError.emailIsNotVerified
        }
        
        guard try await req.password.async.verify(loginRequest.password, created: user.password ?? "") else {
            throw AuthenticationError.invalidEmailOrPassword
        }
        
        req.auth.login(user)
    }
}

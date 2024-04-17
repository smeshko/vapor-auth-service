import Entities
import JWT
import Vapor
import Fluent

struct AuthController {
    
    func authWithApple(_ req: Request) async throws -> Auth.Apple.Response {
        let request = try req.content.decode(Auth.Apple.Request.self)
        
        let appleIdentityToken = try await req.jwt.apple.verify(
            request.appleIdentityToken,
            applicationIdentifier: Environment.appIdentifier
        )
        
        if let user = try await req.repositories.users.find(appleUserIdentifier: appleIdentityToken.subject.value) {
            if let email = appleIdentityToken.email {
                user.email = email
            }
            if let firstName = request.firstName {
                user.firstName = firstName
            }
            if let lastName = request.lastName {
                user.lastName = lastName
            }

            try await req.repositories.users.update(user)
            try await req.repositories.refreshTokens.delete(forUserID: try user.requireID())
            
            let token = req.random.generate(bits: 256)
            let refreshToken = RefreshTokenModel(value: SHA256.hash(token), userID: try user.requireID())
            
            try await req.repositories.refreshTokens.create(refreshToken)

            return Auth.Apple.Response(
                token: try .init(token: token, user: user, on: req),
                user: try .init(from: user)
            )
        } else {
            guard let email = appleIdentityToken.email else {
                throw AuthenticationError.invalidEmailOrPassword
            }
            let user = UserAccountModel(
                email: email,
                password: nil,
                firstName: request.firstName.nilOrNonEmptyValue,
                lastName: request.lastName.nilOrNonEmptyValue,
                appleUserIdentifier: appleIdentityToken.subject.value,
                isEmailVerified: true
            )
            
            do {
                try await req.repositories.users.create(user)
            } catch is DatabaseError {
                throw AuthenticationError.emailAlreadyExists
            }
            
            let token = req.random.generate(bits: 256)
            let refreshToken = RefreshTokenModel(value: SHA256.hash(token), userID: try user.requireID())
            
            try await req.repositories.refreshTokens.create(refreshToken)
            return Auth.Apple.Response(
                token: try .init(token: token, user: user, on: req),
                user: try .init(from: user)
            )
        }
    }
    
    func signIn(_ req: Request) async throws -> Auth.Login.Response {
        let user = try req.auth.require(UserAccountModel.self)
        try await req.repositories.refreshTokens.delete(forUserID: try user.requireID())
        
        let token = req.random.generate(bits: 256)
        let refreshToken = RefreshTokenModel(value: SHA256.hash(token), userID: try user.requireID())
        
        try await req.repositories.refreshTokens.create(refreshToken)

        return Auth.Login.Response(
            token: try .init(token: token, user: user, on: req),
            user: try .init(from: user)
        )
    }
    
    func signUp(_ req: Request) async throws -> Auth.SignUp.Response {
        try Auth.SignUp.Request.validate(content: req)
        let registerRequest = try req.content.decode(Auth.SignUp.Request.self)

        let hash = try await req.password.async.hash(registerRequest.password)
        let user = UserAccountModel(
            email: registerRequest.email.lowercased(),
            password: hash,
            firstName: registerRequest.firstName.nilOrNonEmptyValue,
            lastName: registerRequest.lastName.nilOrNonEmptyValue
        )
        
        do {
            try await req.repositories.users.create(user)
        } catch is DatabaseError {
            throw AuthenticationError.emailAlreadyExists
        }
        
        if let location = registerRequest.location {
            let locationModel = try LocationModel(
                db: user,
                request: location
            )
            try await req.repositories.users.add(locationModel, to: user)
        }

        let token = req.random.generate(bits: 256)
        let refreshToken = RefreshTokenModel(value: SHA256.hash(token), userID: try user.requireID())
        
        try await req.repositories.refreshTokens.create(refreshToken)
        try await req.emailVerifier.verify(for: user)
        
        return Auth.SignUp.Response(
            token: try .init(token: token, user: user, on: req),
            user: try .init(from: user)
        )
    }
    
    func refreshAccessToken(_ req: Request) async throws -> Auth.TokenRefresh.Response {
        let accessTokenRequest = try req.content.decode(Auth.TokenRefresh.Request.self)
        let hashedRefreshToken = SHA256.hash(accessTokenRequest.refreshToken)
        
        guard let token = try await req.repositories.refreshTokens.find(token: hashedRefreshToken) else {
            throw AuthenticationError.refreshTokenOrUserNotFound
        }
        
        guard token.expiresAt > .now else {
            throw AuthenticationError.refreshTokenHasExpired
        }
        
        guard let user = try await req.repositories.users.find(id: token.$user.id) else {
            throw AuthenticationError.userNotFound
        }
        
        try await req.repositories.refreshTokens.delete(id: token.requireID())
        
        let generatedToken = req.random.generate(bits: 256)
        let newRefreshToken = try RefreshTokenModel(value: SHA256.hash(generatedToken), userID: user.requireID())
        
        let payload = try Payload(with: user)
        let accessToken = try req.jwt.sign(payload)
        
        try await req.repositories.refreshTokens.create(newRefreshToken)
        return .init(
            refreshToken: generatedToken,
            accessToken: accessToken
        )
    }
    
    func logout(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(UserAccountModel.self)
        try await req.repositories.refreshTokens.delete(forUserID: user.requireID())
        req.auth.logout(UserAccountModel.self)
        return .ok
    }
    
    func resetPassword(_ req: Request) async throws -> HTTPStatus {
        let resetPasswordRequest = try req.content.decode(Auth.PasswordReset.Request.self)
        
        guard let user = try await req.repositories.users.find(email: resetPasswordRequest.email) else {
            throw AuthenticationError.userNotFound
        }
        
        try await req.passwordResetter.reset(for: user)
        return .ok
    }
}

private extension Optional where Wrapped == String {
    var nilOrNonEmptyValue: String? {
        guard let self else { return nil }
        return self.isEmpty ? nil : self
    }
}

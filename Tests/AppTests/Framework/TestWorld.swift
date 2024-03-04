@testable import App
import Fluent
import FluentSQLiteDriver
import XCTVapor

class TestWorld {
    let app: Application
    
    // Repositories
    private var tokenRepository: TestRefreshTokenRepository
    private var userRepository: TestUserRepository
    private var emailTokenRepository: TestEmailTokenRepository
    private var passwordTokenRepository: TestPasswordTokenRepository
    private var challengeTokenRepository: TestChallengeTokenRepository
    
    init(app: Application) throws {
        self.app = app
        
        try app.jwt.signers.use(.es256(key: .generate()))
        
        self.tokenRepository = .init()
        self.userRepository = .init()
        self.emailTokenRepository = .init()
        self.passwordTokenRepository = .init()
        self.challengeTokenRepository = .init()
        
        app.repositories.use { _ in self.tokenRepository }
        app.repositories.use { _ in self.userRepository }
        app.repositories.use { _ in self.emailTokenRepository }
        app.repositories.use { _ in self.passwordTokenRepository }
        app.repositories.use { _ in self.challengeTokenRepository }
        
        app.dataClients.use { _ in .test }
        app.email.use(.fake)
        app.appAttests.use(.fake)
    }
}

extension MarketClient {
    static var test: MarketClient {
        .init { .open }
    }
}

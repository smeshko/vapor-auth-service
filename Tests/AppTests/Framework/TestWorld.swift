@testable import App
import Fluent
import FluentSQLiteDriver
import XCTVapor

class TestWorld {
    let app: Application
    
    // Repositories
    private let tokenRepository: TestRefreshTokenRepository = .init()
    private let userRepository: TestUserRepository = .init()
    private let emailTokenRepository: TestEmailTokenRepository = .init()
    private let passwordTokenRepository: TestPasswordTokenRepository = .init()
    private let postRepository: TestPostRepository = .init()
    private let mediaRepository: TestMediaRepository = .init()
    private let commentRepository: TestCommentRepository = .init()
    private let businessRepository: TestBusinessRepository = .init()
    
    init(app: Application) throws {
        self.app = app
        
        try app.jwt.signers.use(.es256(key: .generate()))
        
        app.repositories.use { _ in self.tokenRepository }
        app.repositories.use { _ in self.userRepository }
        app.repositories.use { _ in self.emailTokenRepository }
        app.repositories.use { _ in self.passwordTokenRepository }
        app.repositories.use { _ in self.postRepository }
        app.repositories.use { _ in self.mediaRepository }
        app.repositories.use { _ in self.commentRepository }
        app.repositories.use { _ in self.businessRepository }
        
        app.services.email.use(.fake)
        app.services.fileStorage.use(.fake)
    }
}

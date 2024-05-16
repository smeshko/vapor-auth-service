import Vapor

public extension Application {
    struct Repositories {
        struct Provider {
            static var database: Self {
                .init {
                    $0.repositories.use { DatabaseUserRepository(database: $0.db) }
                    $0.repositories.use { DatabaseEmailTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseRefreshTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabasePasswordTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabasePostRepository(database: $0.db) }
                    $0.repositories.use { DatabaseMediaRepository(database: $0.db) }
                    $0.repositories.use { DatabaseCommentRepository(database: $0.db) }
                    $0.repositories.use { DatabaseChallengeTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseBusinessRepository(database: $0.db) }
                    $0.repositories.use { DatabaseDeviceRepository(database: $0.db) }
                }
            }
            
            let run: (Application) -> ()
        }
        
        final class Storage {
            var makeUserRepository: ((Application) -> any UserRepository)?
            var makeEmailTokenRepository: ((Application) -> any EmailTokenRepository)?
            var makeRefreshTokenRepository: ((Application) -> any RefreshTokenRepository)?
            var makePasswordTokenRepository: ((Application) -> any PasswordTokenRepository)?
            var makePostRepository: ((Application) -> any PostRepository)?
            var makeMediaRepository: ((Application) -> any MediaRepository)?
            var makeCommentRepository: ((Application) -> any CommentRepository)?
            var makeChallengeTokenRepository: ((Application) -> any ChallengeTokenRepository)?
            var makeBusinessRepository: ((Application) -> any BusinessRepository)?
            var makeDeviceRepository: ((Application) -> any DeviceRepository)?
            init() { }
        }
        
        struct Key: StorageKey {
            typealias Value = Storage
        }
        
        let app: Application
        
        func use(_ provider: Provider) {
            provider.run(app)
        }
        
        var storage: Storage {
            if app.storage[Key.self] == nil {
                app.storage[Key.self] = .init()
            }
            
            return app.storage[Key.self]!
        }
    }

    var repositories: Repositories {
        .init(app: self)
    }
}

import Vapor

protocol EmailProvider {
    @discardableResult
    func send(_ email: any Email) async throws -> HTTPStatus
}

extension Application {
    public struct Email {
        typealias EmailFactory = (Application) -> EmailProvider
        
        struct Provider {
            public static var live: Self {
                .init {
                    $0.email.use(BrevoClient.init(app:))
                }
            }
            
            public let run: ((Application) -> Void)
            
            public init(_ run: @escaping ((Application) -> Void)) {
                self.run = run
            }
        }
        
        let app: Application
        
        private final class Storage {
            var makeClient: EmailFactory?
            
            init() {}
        }
        
        private struct Key: StorageKey {
            typealias Value = Storage
        }
        
        private var storage: Storage {
            if app.storage[Key.self] == nil {
                self.initialize()
            }
            
            return app.storage[Key.self]!
        }
        
        func use(_ make: @escaping EmailFactory) {
            storage.makeClient = make
        }
        
        func use(_ provider: Application.Email.Provider) {
            provider.run(app)
        }
        
        private func initialize() {
            app.storage[Key.self] = .init()
            app.email.use(.live)
        }
        
        func client() -> EmailProvider {
            guard let makeClient = storage.makeClient else {
                fatalError("Email provider not configured, use: app.email.use(.real)")
            }
            
            return makeClient(app)
        }
    }
    
    public var email: Application.Email {
        .init(app: self)
    }
    
    func emailProvider() -> EmailProvider {
        email.client()
    }
}

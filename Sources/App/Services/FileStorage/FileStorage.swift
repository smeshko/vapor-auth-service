import Vapor

protocol FileStorageProvider {
    func save(_ file: ByteBuffer, key: String) async throws
    func fetch(_ fileKey: String) async throws -> Data
}

extension Application {
    public struct FileStorage {
        typealias FileStorageFactory = (Application) -> FileStorageProvider
        
        struct Provider {            
            public let run: ((Application) -> Void)
            
            public init(_ run: @escaping ((Application) -> Void)) {
                self.run = run
            }
        }
        
        let app: Application
        
        private final class Storage {
            var makeClient: FileStorageFactory?
            
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
        
        func use(_ make: @escaping FileStorageFactory) {
            storage.makeClient = make
        }
        
        func use(_ provider: Application.FileStorage.Provider) {
            provider.run(app)
        }
        
        private func initialize() {
            app.storage[Key.self] = .init()
        }
        
        func client() -> FileStorageProvider {
            guard let makeClient = storage.makeClient else {
                fatalError("FileStorage provider not configured, use: app.email.use(.real)")
            }
            
            return makeClient(app)
        }
    }
    
    public var fileStorage: Application.FileStorage {
        .init(app: self)
    }
    
    func fileStorageProvider() -> FileStorageProvider {
        fileStorage.client()
    }
}

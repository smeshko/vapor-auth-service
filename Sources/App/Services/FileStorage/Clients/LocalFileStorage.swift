import Vapor

struct LocalFileStorage: FileStorageProvider {
    let app: Application
    
    func save(_ file: ByteBuffer, key: String) async throws {
        print("local file save")
    }
    
    func fetch(_ fileKey: String) async throws -> Data {
        .init()
    }
}

extension Application.FileStorage.Provider {
    static var local: Self {
        .init {
            $0.fileStorage.use(LocalFileStorage.init(app:))
        }
    }
}

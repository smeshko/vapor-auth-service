import XCTVapor
@testable import App

struct FakeFileStorage: FileStorageProvider {
    func fetch(_ fileKey: String) async throws -> Data {
        Data()
    }
    
    func save(_ file: ByteBuffer, key: String) async throws {}
}

struct FakeThrowingFileStorage: FileStorageProvider {
    func fetch(_ fileKey: String) async throws -> Data {
        throw Abort(.badRequest)
    }
    
    func save(_ file: ByteBuffer, key: String) async throws {
        throw Abort(.badRequest)
    }
}

extension Application.FileStorage.Provider {
    static var fake: Self {
        .init {
            $0.fileStorage.use { _ in
                FakeFileStorage()
            }
        }
    }
    
    static var throwing: Self {
        .init {
            $0.fileStorage.use { _ in
                FakeThrowingFileStorage()
            }
        }
    }
}

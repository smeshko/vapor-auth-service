import XCTVapor
@testable import App

struct FakeFileStorage: FileStorageService {
    func `for`(_ request: Request) -> any FileStorageService {
        Self.init()
    }
    
    func fetch(_ fileKey: String, percentageOfOriginalSize: Double?) async throws -> Data {
        Data()
    }
    
    func save(_ file: ByteBuffer, key: String) async throws {}
}

struct FakeThrowingFileStorage: FileStorageService {
    func `for`(_ request: Request) -> any FileStorageService {
        Self.init()
    }
    
    func fetch(_ fileKey: String, percentageOfOriginalSize: Double?) async throws -> Data {
        throw Abort(.badRequest)
    }
    
    func save(_ file: ByteBuffer, key: String) async throws {
        throw Abort(.badRequest)
    }
}

extension Application.Service.Provider where ServiceType == FileStorageService {
    static var fake: Self {
        .init {
            $0.services.fileStorage.use { _ in
                FakeFileStorage()
            }
        }
    }
    
    static var throwing: Self {
        .init {
            $0.services.fileStorage.use { _ in
                FakeThrowingFileStorage()
            }
        }
    }
}

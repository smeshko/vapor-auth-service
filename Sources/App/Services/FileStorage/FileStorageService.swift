import Vapor

protocol FileStorageService {
    func `for`(_ request: Request) -> FileStorageService
    func save(_ file: ByteBuffer, key: String) async throws
    func fetch(_ fileKey: String, percentageOfOriginalSize: Double?) async throws -> Data
}

extension Application.Services {
    var fileStorage: Application.Service<FileStorageService> {
        .init(application: application)
    }
}

extension Request.Services {
    var fileStorage: FileStorageService {
        self.request.application.services.fileStorage.service.for(request)
    }
}

import Vapor

extension Request {
    var fileStorage: FileStorageProvider {
        application.fileStorage.client()
    }
}

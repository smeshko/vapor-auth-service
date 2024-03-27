import Common
import Entities
import Fluent
import Vapor

protocol MediaRepository: Repository {
    func find(id: UUID?) async throws -> MediaModel?
    func create(_ model: MediaModel) async throws
    func all() async throws -> [MediaModel]
    func all(forPostID id: UUID) async throws -> [MediaModel]
    func update(_ model: MediaModel) async throws
}

struct DatabaseMediaRepository: MediaRepository, DatabaseRepository {
    typealias Model = MediaModel
    
    let database: Database
    
    func find(id: UUID?) async throws -> MediaModel? {
        try await MediaModel.find(id, on: database)
    }
    
    func create(_ model: MediaModel) async throws {
        try await model.create(on: database)
    }
    
    func all() async throws -> [MediaModel] {
        try await MediaModel.query(on: database).all()
    }
    
    func all(forPostID id: UUID) async throws -> [MediaModel] {
        []
//        try await PostModel.query(on: database)
//            .filter(\.$user.$id == id)
//            .all()
    }
    
    func update(_ model: MediaModel) async throws {
        try await model.update(on: database)
    }
}

extension Application.Repositories {
    var media: any MediaRepository {
        guard let storage = storage.makeMediaRepository else {
            fatalError("MediaRepository not configured, use: app.mediaRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (any MediaRepository)) {
        storage.makeMediaRepository = make
    }
}


import Common
import Entities
import Fluent
import Vapor

protocol PostRepository: Repository {
    func find(id: UUID?) async throws -> PostModel?
    func create(_ model: PostModel) async throws
    func all() async throws -> [PostModel]
    func all(forUserId id: UUID) async throws -> [PostModel]
    func update(_ model: PostModel) async throws
}

struct DatabasePostRepository: PostRepository, DatabaseRepository {
    typealias Model = PostModel
    
    let database: Database
    
    func find(id: UUID?) async throws -> PostModel? {
        try await PostModel.find(id, on: database)
    }
    
    func create(_ model: PostModel) async throws {
        try await model.create(on: database)
    }
    
    func all() async throws -> [PostModel] {
        try await PostModel.query(on: database).all()
    }
    
    func all(forUserId id: UUID) async throws -> [PostModel] {
        try await PostModel.query(on: database)
            .filter(\.$user.$id == id)
            .all()
    }
    
    func update(_ model: PostModel) async throws {
        try await model.update(on: database)
    }
}

extension Application.Repositories {
    var posts: any PostRepository {
        guard let storage = storage.makePostRepository else {
            fatalError("PostRepository not configured, use: app.postRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (any PostRepository)) {
        storage.makePostRepository = make
    }
}


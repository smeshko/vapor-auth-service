import Common
import Entities
import Fluent
import Vapor

protocol CommentRepository: Repository {
    func find(id: UUID) async throws -> CommentModel?
    func create(_ model: CommentModel) async throws
    func all(forUserId id: UUID) async throws -> [CommentModel]
    func all(forPostId id: UUID) async throws -> [CommentModel]
    func update(_ model: CommentModel) async throws
}

struct DatabaseCommentRepository: CommentRepository, DatabaseRepository {
    typealias Model = CommentModel
    
    let database: Database
    
    func find(id: UUID) async throws -> CommentModel? {
        try await CommentModel.query(on: database)
            .filter(\.$id == id)
            .with(\.$user)
            .with(\.$post)
            .first()
    }
    
    func create(_ model: CommentModel) async throws {
        try await model.create(on: database)
    }
    
    func all(forUserId id: UUID) async throws -> [CommentModel] {
        try await CommentModel.query(on: database)
            .filter(\.$user.$id == id)
            .all()
    }
    
    func all(forPostId id: UUID) async throws -> [CommentModel] {
        try await CommentModel.query(on: database)
            .filter(\.$post.$id == id)
            .with(\.$user)
            .all()
    }
    
    func update(_ model: CommentModel) async throws {
        try await model.update(on: database)
    }
}

extension Application.Repositories {
    var comments: any CommentRepository {
        guard let storage = storage.makeCommentRepository else {
            fatalError("CommentRepository not configured, use: app.commentRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (any CommentRepository)) {
        storage.makeCommentRepository = make
    }
}


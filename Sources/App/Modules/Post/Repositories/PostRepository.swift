import Common
import Entities
import Fluent
import Vapor

protocol PostRepository: Repository {
    func find(id: UUID) async throws -> PostModel?
    func create(_ model: PostModel) async throws
    func all(forUserId id: UUID) async throws -> [PostModel]
    func all() async throws -> [PostModel]
    func update(_ model: PostModel) async throws
    
    func user(_ user: UserAccountModel, likes post: PostModel) async throws
    func user(_ user: UserAccountModel, dislikes post: PostModel) async throws
    func loadLikes(for post: PostModel) async throws
}

struct DatabasePostRepository: PostRepository, DatabaseRepository {
    typealias Model = PostModel
    
    let database: Database

    func find(id: UUID) async throws -> PostModel? {
        try await PostModel
            .query(on: database)
            .filter(\.$id == id)
            .with(\.$user, {
                $0.with(\.$location)
                $0.with(\.$followers)
                $0.with(\.$following)
            })
            .with(\.$comments, { $0.with(\.$user) })
            .with(\.$likedBy)
            .first()
    }
    
    func create(_ model: PostModel) async throws {
        try await model.create(on: database)
    }
    
    func all() async throws -> [PostModel] {
        try await PostModel.query(on: database)
            .with(\.$user)
            .with(\.$comments)
            .with(\.$likedBy)
            .all()
    }
    
    func all(forUserId id: UUID) async throws -> [PostModel] {
        try await PostModel.query(on: database)
            .filter(\.$user.$id == id)
            .with(\.$user)
            .with(\.$comments)
            .with(\.$likedBy)
            .all()
    }
    
    func update(_ model: PostModel) async throws {
        try await model.update(on: database)
    }
}

// MARK: - LikeModel
extension DatabasePostRepository {
    func user(_ user: UserAccountModel, likes post: PostModel) async throws {
        try await user.$likes.attach(post, method: .ifNotExists, on: database)
        try await post.$likedBy.load(on: database)
    }
    
    func user(_ user: UserAccountModel, dislikes post: PostModel) async throws {
        try await user.$likes.detach(post, on: database)
    }
    
    func loadLikes(for post: PostModel) async throws {
        try await post.$likedBy.load(on: database)
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


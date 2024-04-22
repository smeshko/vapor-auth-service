@testable import App
import Vapor
import Fluent
import Entities

class TestPostRepository: PostRepository, TestRepository {
    var posts: [PostModel]
    
    init(posts: [PostModel] = []) {
        self.posts = posts
    }
    
    typealias Model = PostModel
    
    func find(id: UUID?) async throws -> PostModel? {
        posts.first(where: { $0.id == id })
    }
    
    func create(_ model: PostModel) async throws {
        model.id = model.id ?? UUID()
        posts.append(model)
    }
    
    func all() async throws -> [PostModel] {
        posts
    }
    
    func all(forUserId id: UUID) async throws -> [PostModel] {
        posts.filter { $0.$user.id == id }
    }
    
    func update(_ model: PostModel) async throws {
        let index = posts.firstIndex(where: { $0.id == model.id })!
        posts.remove(at: index)
        posts.insert(model, at: index)
    }
    
    func delete(id: UUID) async throws {
        posts.removeAll(where: { $0.id == id })
    }
    
    func count() async throws -> Int {
        posts.count
    }
}

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
    
    func find(id: UUID) async throws -> PostModel? {
        let post = posts.first(where: { $0.id == id })
        return post
    }
    
    func create(_ model: PostModel) async throws {
        model.id = model.id ?? UUID()
        model.$likedBy.value = []
        posts.append(model)
    }
    
    func all() async throws -> [PostModel] {
        posts
    }
    
    func all(tag: String?, category: String?) async throws -> [PostModel] {
        var result: [PostModel] = []
        if let tag {
            result.append(contentsOf: posts.filter { $0.tags.contains(tag) })
        }
        if let category {
            result.append(contentsOf: posts.filter { $0.category == category })
        }
        return result
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
    
    func user(_ user: UserAccountModel, likes post: PostModel) async throws {
        post.$likedBy.value?.append(user)
    }
    
    func user(_ user: UserAccountModel, dislikes post: PostModel) async throws {
        post.$likedBy.value?.removeAll(where: { $0.id == user.id})
    }
    
    func loadLikes(for post: PostModel) async throws {}
}

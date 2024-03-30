@testable import App
import Vapor
import Entities

class TestCommentRepository: CommentRepository, TestRepository {
    typealias Model = CommentModel
    var models: [CommentModel]
    
    init(models: [CommentModel] = []) {
        self.models = models
    }
    
    func find(id: UUID) async throws -> CommentModel? {
        models.first(where: { $0.id == id })
    }
    
    func create(_ model: CommentModel) async throws {
        model.id = model.id ?? UUID()
        models.append(model)
    }
    
    func all(forUserId id: UUID) async throws -> [CommentModel] {
        models.filter { $0.$user.id == id }
    }
    
    func update(_ model: CommentModel) async throws {
        let index = models.firstIndex(where: { $0.id == model.id })!
        models.remove(at: index)
        models.insert(model, at: index)
    }
    
    func delete(id: UUID) async throws {
        models.removeAll(where: { $0.id == id })
    }
    
    func count() async throws -> Int {
        models.count
    }
}

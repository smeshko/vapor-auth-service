@testable import App
import Vapor
import Entities

class TestMediaRepository: MediaRepository, TestRepository {
    typealias Model = MediaModel
    var models: [MediaModel]
    
    init(models: [MediaModel] = []) {
        self.models = models
    }
    
    func find(id: UUID?) async throws -> App.MediaModel? {
        models.first(where: { $0.id == id })
    }
    
    func create(_ model: App.MediaModel) async throws {
        model.id = model.id ?? UUID()
        models.append(model)
    }
    
    func update(_ model: App.MediaModel) async throws {
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

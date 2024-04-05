@testable import App
import Vapor
import Entities

class TestBusinessRepository: BusinessRepository, TestRepository {
    typealias Model = BusinessAccountModel
    var models: [BusinessAccountModel]
    
    init(models: [BusinessAccountModel] = []) {
        self.models = models
    }
    
    func find(id: UUID) async throws -> BusinessAccountModel? {
        models.first(where: { $0.id == id })
    }
    
    func create(_ model: BusinessAccountModel) async throws {
        model.id = model.id ?? UUID()
        model.$openingHours.value = []
        models.append(model)
    }
    
    func update(_ model: BusinessAccountModel) async throws {
        let index = models.firstIndex(where: { $0.id == model.id })!
        models.remove(at: index)
        models.insert(model, at: index)
    }
    
    func all() async throws -> [BusinessAccountModel] {
        models
    }
    
    func create(_ model: OpeningHoursModel) async throws {
        model.id = model.id ?? UUID()
        models.first(where: { $0.id == model.business.id })?.openingHours.append(model)
    }
    
    func create(_ models: [OpeningHoursModel]) async throws {
        self.models.first(where: { $0.id == models.first?.$business.id })?.$openingHours.value = models
    }
    
    func update(_ model: OpeningHoursModel) async throws {
        let business = models.first(where: { $0.id == model.business.id })!
        let hoursIndex = business.openingHours.firstIndex(where: { $0.id == model.id })!
        business.openingHours.insert(model, at: hoursIndex)
    }

    func delete(id: UUID) async throws {
        models.removeAll(where: { $0.id == id })
    }
    
    func count() async throws -> Int {
        models.count
    }
}

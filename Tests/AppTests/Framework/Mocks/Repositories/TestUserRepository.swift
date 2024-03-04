@testable import App
import Vapor
import Fluent
import Entities

class TestUserRepository: UserRepository, TestRepository {
    var users: [UserAccountModel]
    
    init(users: [UserAccountModel] = []) {
        self.users = users
    }
    
    typealias Model = UserAccountModel
    
    func create(_ model: UserAccountModel) async throws {
        model.id = model.id ?? UUID()
        users.append(model)
    }

    func delete(id: UUID) async throws {
        users.removeAll(where: { $0.id == id })
    }
    
    func find(email: String) async throws -> UserAccountModel? {
        users.first(where: { $0.email == email })
    }
    
    func set<Field>(_ field: KeyPath<UserAccountModel, Field>, to value: Field.Value, for userID: UUID) async throws where Field : QueryableProperty, Field.Model == UserAccountModel {
        let user = users.first(where: { $0.id == userID })!
        user[keyPath: field].value = value
    }
    
    func count() async throws -> Int {
        users.count
    }
    
    func find(id: UUID?) async throws -> UserAccountModel? {
        users.first(where: { $0.id == id })
    }
    
    func all() async throws -> [UserAccountModel] {
        users
    }
    
    func update(_ model: UserAccountModel) async throws {
        let index = users.firstIndex(where: { $0.id == model.id })!
        users.remove(at: index)
        users.insert(model, at: index)
    }
}

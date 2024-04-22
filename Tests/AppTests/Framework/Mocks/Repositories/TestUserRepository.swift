@testable import App
import Vapor
import Fluent
import Entities

class TestUserRepository: UserRepository, TestRepository {
    var users: [UserAccountModel]
    var locations: [UUID: LocationModel] = [:]
    
    init(users: [UserAccountModel] = []) {
        self.users = users
    }
    
    typealias Model = UserAccountModel
    
    func create(_ model: UserAccountModel) async throws {
        model.id = model.id ?? UUID()
        model.$posts.value = []
        model.$comments.value = []
        users.append(model)
    }

    func delete(id: UUID) async throws {
        users.removeAll(where: { $0.id == id })
    }
    
    func find(email: String) async throws -> UserAccountModel? {
        if let user = users.first(where: { $0.email == email }) {
            user.$location.value = locations[user.id!]
            return user
        } else {
            return users.first(where: { $0.email == email })
        }
    }
    
    func find(appleUserIdentifier: String) async throws -> UserAccountModel? {
        users.first(where: { $0.appleUserIdentifier == appleUserIdentifier })
    }
    
    func set<Field>(_ field: KeyPath<UserAccountModel, Field>, to value: Field.Value, for userID: UUID) async throws where Field : QueryableProperty, Field.Model == UserAccountModel {
        let user = users.first(where: { $0.id == userID })!
        user[keyPath: field].value = value
    }
    
    func count() async throws -> Int {
        users.count
    }
    
    func find(id: UUID) async throws -> UserAccountModel? {
        if let user = users.first(where: { $0.id == id }) {
            user.$location.value = locations[user.id!]
            return user
        } else {
            return users.first(where: { $0.id == id })
        }
    }
    
    func all() async throws -> [UserAccountModel] {
        users
    }
    
    func update(_ model: UserAccountModel) async throws {
        let index = users.firstIndex(where: { $0.id == model.id })!
        users.remove(at: index)
        users.insert(model, at: index)
        model.$location.value = locations[model.id!]
    }
    
    func add(_ location: LocationModel, to user: UserAccountModel) async throws {
        locations[user.id!] = location
    }
    
    func update(_ model: LocationModel) async throws {
        locations[model.$user.id] = model
    }
    
    func getLocation(for user: UserAccountModel) async throws -> LocationModel? {
        user.$location.value = locations[user.id!]
        return locations[user.id!]
    }
    
    func loadLocation(for user: UserAccountModel) async throws {
        user.$location.value = locations[user.id!]
    }
}

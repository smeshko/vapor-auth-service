import Common
import Entities
import Fluent
import Vapor

protocol UserRepository: Repository {
    func find(email: String) async throws -> UserAccountModel?
    func find(id: UUID) async throws -> UserAccountModel?
    func find(appleUserIdentifier: String) async throws -> UserAccountModel?
    func create(_ model: UserAccountModel) async throws
    func all() async throws -> [UserAccountModel]
    func update(_ model: UserAccountModel) async throws
}

struct DatabaseUserRepository: UserRepository, DatabaseRepository {
    typealias Model = UserAccountModel
    
    let database: Database
    
    func find(appleUserIdentifier: String) async throws -> UserAccountModel? {
        try await UserAccountModel.query(on: database)
            .filter(\.$appleUserIdentifier == appleUserIdentifier)
            .with(\.$posts)
            .with(\.$comments)
            .first()
    }

    func find(email: String) async throws -> UserAccountModel? {
        try await UserAccountModel.query(on: database)
            .filter(\.$email == email)
            .with(\.$posts)
            .with(\.$comments)
            .first()
    }
    
    func all() async throws -> [UserAccountModel] {
        try await UserAccountModel.query(on: database).all()
    }
    
    func find(id: UUID) async throws -> UserAccountModel? {
        try await UserAccountModel.query(on: database)
            .filter(\.$id == id)
            .with(\.$posts)
            .with(\.$comments)
            .first()
    }
    
    func create(_ model: UserAccountModel) async throws {
        try await model.create(on: database)
    }
    
    func update(_ model: UserAccountModel) async throws {
        try await model.update(on: database)
    }
}

extension Application.Repositories {
    var users: any UserRepository {
        guard let storage = storage.makeUserRepository else {
            fatalError("UserRepository not configured, use: app.userRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (any UserRepository)) {
        storage.makeUserRepository = make
    }
}

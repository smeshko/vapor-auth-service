import Common
import Entities
import Fluent
import Vapor

protocol UserRepository: Repository {
    func find(id: UUID) async throws -> UserAccountModel?
    func find(email: String) async throws -> UserAccountModel?
    func find(appleUserIdentifier: String) async throws -> UserAccountModel?
    func create(_ model: UserAccountModel) async throws
    func all() async throws -> [UserAccountModel]
    func update(_ model: UserAccountModel) async throws
    
    func add(_ location: LocationModel, to user: UserAccountModel) async throws
    func update(_ model: LocationModel) async throws
    func getLocation(for user: UserAccountModel) async throws -> LocationModel?
    func loadLocation(for user: UserAccountModel) async throws
}

struct DatabaseUserRepository: UserRepository, DatabaseRepository {
    typealias Model = UserAccountModel
    
    let database: Database

    func find(appleUserIdentifier: String) async throws -> UserAccountModel? {
        try await UserAccountModel.query(on: database)
            .filter(\.$appleUserIdentifier == appleUserIdentifier)
            .with(\.$posts)
            .with(\.$comments)
            .with(\.$location)
            .first()
    }

    func find(email: String) async throws -> UserAccountModel? {
        try await UserAccountModel.query(on: database)
            .filter(\.$email == email)
            .with(\.$posts)
            .with(\.$comments)
            .with(\.$location)
            .first()
    }
    
    func find(id: UUID) async throws -> UserAccountModel? {
        try await UserAccountModel.query(on: database)
            .filter(\.$id == id)
            .with(\.$posts)
            .with(\.$comments)
            .with(\.$location)
            .first()
    }
    
    func all() async throws -> [UserAccountModel] {
        try await UserAccountModel.query(on: database).all()
    }
    
    func create(_ model: UserAccountModel) async throws {
        try await model.create(on: database)
    }
    
    func update(_ model: UserAccountModel) async throws {
        try await model.update(on: database)
    }
}

// MARK: - LocationModel
extension DatabaseUserRepository {
    func add(_ location: LocationModel, to user: UserAccountModel) async throws {
        try await user.$location.create(location, on: database)
    }
    
    func update(_ model: LocationModel) async throws {
        try await model.update(on: database)
    }
    
    func getLocation(for user: UserAccountModel) async throws -> LocationModel? {
        try await user.$location.get(on: database)
    }
    
    func loadLocation(for user: UserAccountModel) async throws {
        try await user.$location.load(on: database)
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

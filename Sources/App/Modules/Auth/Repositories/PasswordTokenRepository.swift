import Vapor
import Fluent

protocol PasswordTokenRepository: Repository {
    func find(forUserID id: UUID) async throws -> PasswordTokenModel?
    func find(token: String) async throws -> PasswordTokenModel?
    func delete(forUserID id: UUID) async throws
    func create(_ model: PasswordTokenModel) async throws
    func all() async throws -> [PasswordTokenModel]
    func find(id: UUID) async throws -> PasswordTokenModel?
}

struct DatabasePasswordTokenRepository: PasswordTokenRepository, DatabaseRepository {
    typealias Model = PasswordTokenModel
    
    var database: Database
    
    func find(forUserID id: UUID) async throws -> PasswordTokenModel? {
        try await PasswordTokenModel.query(on: database)
            .filter(\.$user.$id == id)
            .with(\.$user)
            .first()
     }
    
    func find(token: String) async throws -> PasswordTokenModel? {
        try await PasswordTokenModel.query(on: database)
            .filter(\.$value == token)
            .with(\.$user)
            .first()
    }

    func delete(forUserID id: UUID) async throws {
        try await PasswordTokenModel.query(on: database)
            .filter(\.$user.$id == id)
            .delete()
    }
    
    func all() async throws -> [PasswordTokenModel] {
        try await PasswordTokenModel
            .query(on: database)
            .with(\.$user)
            .all()
    }
    
    func find(id: UUID) async throws -> PasswordTokenModel? {
        try await PasswordTokenModel
            .query(on: database)
            .filter(\.$id == id)
            .with(\.$user)
            .first()
    }
    
    func create(_ model: PasswordTokenModel) async throws {
        try await model.create(on: database)
    }
}

extension Application.Repositories {
    var passwordTokens: any PasswordTokenRepository {
        guard let factory = storage.makePasswordTokenRepository else {
            fatalError("PasswordToken repository not configured, use: app.repositories.use")
        }
        return factory(app)
    }
    
    func use(_ make: @escaping (Application) -> (any PasswordTokenRepository)) {
        storage.makePasswordTokenRepository = make
    }
}

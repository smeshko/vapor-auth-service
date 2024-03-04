import Entities
import Fluent
import Vapor

protocol ChallengeTokenRepository: Repository {
    func find(value: String) async throws -> ChallengeTokenModel?
    func create(_ model: ChallengeTokenModel) async throws
}

struct DatabaseChallengeTokenRepository: ChallengeTokenRepository, DatabaseRepository {
    typealias Model = ChallengeTokenModel
    let database: Database
    
    func find(value: String) async throws -> ChallengeTokenModel? {
        try await ChallengeTokenModel.query(on: database)
            .filter(\.$value == value)
            .first()
    }
    
    func create(_ model: ChallengeTokenModel) async throws {
        try await model.create(on: database)
    }
}

extension Application.Repositories {
    var challengeTokens: any ChallengeTokenRepository {
        guard let factory = storage.makeChallengeTokenRepository else {
            fatalError("ChallengeToken repository not configured, use: app.repositories.use")
        }
        return factory(app)
    }
    
    func use(_ make: @escaping (Application) -> (any ChallengeTokenRepository)) {
        storage.makeChallengeTokenRepository = make
    }
}

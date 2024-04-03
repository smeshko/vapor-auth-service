import Common
import Entities
import Fluent
import Vapor

protocol BusinessRepository: Repository {
    func find(id: UUID) async throws -> BusinessAccountModel?
    func create(_ model: BusinessAccountModel) async throws
    func update(_ model: BusinessAccountModel) async throws
    func all() async throws -> [BusinessAccountModel]
    
    func create(_ model: OpeningHoursModel) async throws
    func create(_ models: [OpeningHoursModel]) async throws
    func update(_ model: OpeningHoursModel) async throws
    
    func add(_ location: LocationModel, to business: BusinessAccountModel) async throws
    func update(_ model: LocationModel) async throws
}

struct DatabaseBusinessRepository: BusinessRepository, DatabaseRepository {
    typealias Model = BusinessAccountModel
    
    let database: Database
}

// MARK: - BusinessAccountModel
extension DatabaseBusinessRepository {
    func find(id: UUID) async throws -> BusinessAccountModel? {
        try await BusinessAccountModel.query(on: database)
            .filter(\.$id == id)
            .with(\.$user)
            .with(\.$openingHours)
            .with(\.$location)
            .first()
    }
    
    func create(_ model: BusinessAccountModel) async throws {
        try await model.create(on: database)
    }

    func update(_ model: BusinessAccountModel) async throws {
        try await model.update(on: database)
    }

    func all() async throws -> [BusinessAccountModel] {
        try await BusinessAccountModel.query(on: database).all()
    }
}

// MARK: - OpeningHoursModel
extension DatabaseBusinessRepository {
    func create(_ model: OpeningHoursModel) async throws {
        try await model.create(on: database)
    }

    func create(_ models: [OpeningHoursModel]) async throws {
        try await models.asyncForEach { model in
            try await model.create(on: database)
        }
    }

    func update(_ model: OpeningHoursModel) async throws {
        try await model.update(on: database)
    }
}

// MARK: - LocationModel
extension DatabaseBusinessRepository {
    func add(_ location: LocationModel, to business: BusinessAccountModel) async throws {
        try await business.$location.create(location, on: database)
    }
    
    func update(_ model: LocationModel) async throws {
        try await model.update(on: database)
    }
}

extension Application.Repositories {
    var businesses: any BusinessRepository {
        guard let storage = storage.makeBusinessRepository else {
            fatalError("BusinessRepository not configured, use: app.businessRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (any BusinessRepository)) {
        storage.makeBusinessRepository = make
    }
}

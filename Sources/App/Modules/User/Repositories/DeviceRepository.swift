import Common
import Entities
import Fluent
import Vapor

protocol DeviceRepository: Repository {
    func find(id: UUID) async throws -> DeviceModel?
    func find(for user: UserAccountModel) async throws -> [DeviceModel]
    func create(_ model: DeviceModel) async throws
    func all() async throws -> [DeviceModel]
    func update(_ model: DeviceModel) async throws
}

struct DatabaseDeviceRepository: DeviceRepository, DatabaseRepository {
    
    typealias Model = DeviceModel
    
    let database: Database

    func find(id: UUID) async throws -> DeviceModel? {
        try await DeviceModel.query(on: database)
            .filter(\.$id == id)
            .first()
    }
    
    func find(for user: UserAccountModel) async throws -> [DeviceModel] {
        try await DeviceModel
            .query(on: database)
            .filter(\.$id == user.requireID())
            .all()
    }
    
    func create(_ model: DeviceModel) async throws {
        try await model.create(on: database)
    }
    
    func all() async throws -> [DeviceModel] {
        try await DeviceModel
            .query(on: database)
            .all()
    }
    
    func update(_ model: DeviceModel) async throws {
        try await model.update(on: database)
    }
}

extension Application.Repositories {
    var devices: any DeviceRepository {
        guard let storage = storage.makeDeviceRepository else {
            fatalError("DeviceRepository not configured, use: app.deviceRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (any DeviceRepository)) {
        storage.makeDeviceRepository = make
    }
}

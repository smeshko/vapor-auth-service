import Common
import Entities
import Fluent
import Vapor

protocol ProductRepository: Repository {
    func find(id: UUID) async throws -> ProductModel?
    func create(_ model: ProductModel) async throws
    func all() async throws -> [ProductModel]
    func update(_ model: ProductModel) async throws
}

struct DatabaseProductRepository: ProductRepository, DatabaseRepository {
    
    typealias Model = ProductModel
    
    let database: Database
    
    func find(id: UUID) async throws -> ProductModel? {
        try await ProductModel.query(on: database)
            .filter(\.$id == id)
            .first()
    }
    
    func create(_ model: ProductModel) async throws {
        try await model.create(on: database)
    }
    
    func all() async throws -> [ProductModel] {
        try await ProductModel
            .query(on: database)
            .all()
    }
    
    func update(_ model: ProductModel) async throws {
        try await model.update(on: database)
    }
}

extension Application.Repositories {
    var products: any ProductRepository {
        guard let storage = storage.makeProductRepository else {
            fatalError("ProductRepository not configured, use: app.productRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (any ProductRepository)) {
        storage.makeProductRepository = make
    }
}


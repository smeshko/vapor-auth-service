import Common
import Entities
import Fluent
import Vapor

protocol ShoppingListRepository: Repository {
    func find(id: UUID) async throws -> ShoppingListModel?
    func find(for user: UserAccountModel, category: String) async throws -> ShoppingListModel?
    func create(_ model: ShoppingListModel) async throws
    func createItem(_ model: ShoppingListItemModel) async throws
    func all() async throws -> [ShoppingListModel]
    func update(_ model: ShoppingListModel) async throws
    
    func deals(for user: UserAccountModel) async throws -> ShoppingListModel?
    func premium(for user: UserAccountModel) async throws -> ShoppingListModel?
}

struct DatabaseShoppingListRepository: ShoppingListRepository, DatabaseRepository {
    
    typealias Model = ShoppingListModel
    
    let database: Database
    
    func find(id: UUID) async throws -> ShoppingListModel? {
        try await ShoppingListModel.query(on: database)
            .filter(\.$id == id)
            .first()
    }
    
    func create(_ model: ShoppingListModel) async throws {
        try await model.create(on: database)
    }
    
    func createItem(_ model: ShoppingListItemModel) async throws {
        try await model.create(on: database)
    }
    
    func all() async throws -> [ShoppingListModel] {
        try await ShoppingListModel
            .query(on: database)
            .all()
    }
    
    func update(_ model: ShoppingListModel) async throws {
        try await model.update(on: database)
    }
    
    func find(for user: UserAccountModel, category: String) async throws -> ShoppingListModel? {
        try await ShoppingListModel.query(on: database)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$category == category)
            .with(\.$items, { $0.with(\.$product) })
            .first()
    }
    
    func deals(for user: UserAccountModel) async throws -> ShoppingListModel? {
        try await ShoppingListModel.query(on: database)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$category == "deals")
            .with(\.$items, { $0.with(\.$product) })
            .first()
    }
    
    func premium(for user: UserAccountModel) async throws -> ShoppingListModel? {
        try await ShoppingListModel.query(on: database)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$category == "premium")
            .with(\.$items, { $0.with(\.$product) })
            .first()
    }
}

extension Application.Repositories {
    var shoppingLists: any ShoppingListRepository {
        guard let storage = storage.makeShoppingListRepository else {
            fatalError("ShoppingListRepository not configured, use: app.ShoppingListRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (any ShoppingListRepository)) {
        storage.makeShoppingListRepository = make
    }
}


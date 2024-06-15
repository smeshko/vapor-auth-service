import Common
import Fluent
import Vapor

final class ShoppingListModel: DatabaseModelInterface {
    typealias Module = ShoppingListModule
    static var schema: String { "shopping_lists" }
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.v1.category)
    var category: String
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel
    
    @Children(for: \.$shoppingList)
    var items: [ShoppingListItemModel]
    
    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
    
}

extension ShoppingListModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var category: FieldKey { "category" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}


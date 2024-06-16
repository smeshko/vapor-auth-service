import Common
import Fluent
import Vapor

final class ShoppingListItemModel: DatabaseModelInterface {
    typealias Module = ShoppingListModule
    static var schema: String { "shopping_list_items" }
    
    @ID()
    var id: UUID?
    
    @Parent(key: FieldKeys.v1.shoppingListId)
    var shoppingList: ShoppingListModel
    
    @Parent(key: FieldKeys.v1.productId)
    var product: ProductModel
    
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
        deletedAt: Date? = nil,
        shoppingListId: UUID,
        productId: UUID
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.$shoppingList.id = shoppingListId
        self.$product.id = productId
    }
}

extension ShoppingListItemModel {
    struct FieldKeys {
        struct v1 {
            static var shoppingListId: FieldKey { "shopping_list_id" }
            static var productId: FieldKey { "product_id" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}


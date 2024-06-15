import Common
import Fluent
import Vapor

enum ShoppingListItemMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(ShoppingListItemModel.schema)
                .id()
                .field(ShoppingListItemModel.FieldKeys.v1.createdAt, .datetime)
                .field(ShoppingListItemModel.FieldKeys.v1.updatedAt, .datetime)
                .field(ShoppingListItemModel.FieldKeys.v1.deletedAt, .datetime)
                .field(ShoppingListItemModel.FieldKeys.v1.shoppingListId, .uuid, .required)
                .foreignKey(
                    ShoppingListItemModel.FieldKeys.v1.shoppingListId,
                    references: ShoppingListModel.schema, .id,
                    onDelete: .cascade
                )
                .field(ShoppingListItemModel.FieldKeys.v1.productId, .uuid, .required)
                .foreignKey(
                    ShoppingListItemModel.FieldKeys.v1.productId,
                    references: ProductModel.schema, .id,
                    onDelete: .cascade
                )
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(ShoppingListItemModel.schema).delete()
        }
    }
}


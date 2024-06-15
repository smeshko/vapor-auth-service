import Common
import Fluent
import Vapor

enum ShoppingListMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(ShoppingListModel.schema)
                .id()
                .field(ShoppingListModel.FieldKeys.v1.createdAt, .datetime)
                .field(ShoppingListModel.FieldKeys.v1.updatedAt, .datetime)
                .field(ShoppingListModel.FieldKeys.v1.deletedAt, .datetime)
                .field(ShoppingListModel.FieldKeys.v1.category, .string, .required)
                .field(ShoppingListModel.FieldKeys.v1.userId, .uuid, .required)
                .foreignKey(
                    ShoppingListModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id,
                    onDelete: .cascade
                )
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(ShoppingListModel.schema).delete()
        }
    }
}

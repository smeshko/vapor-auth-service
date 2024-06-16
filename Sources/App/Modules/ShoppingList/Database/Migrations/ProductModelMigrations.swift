import Common
import Fluent
import Vapor

enum ProductModelMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(ProductModel.schema)
                .id()
                .field(ProductModel.FieldKeys.v1.createdAt, .datetime)
                .field(ProductModel.FieldKeys.v1.updatedAt, .datetime)
                .field(ProductModel.FieldKeys.v1.deletedAt, .datetime)
                .field(ProductModel.FieldKeys.v1.imageId, .uuid, .required)
                .field(ProductModel.FieldKeys.v1.name, .string, .required)
                .field(ProductModel.FieldKeys.v1.category, .string, .required)
                .unique(on: ProductModel.FieldKeys.v1.name)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(ProductModel.schema).delete()
        }
    }
}

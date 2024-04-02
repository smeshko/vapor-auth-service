import Common
import Fluent
import Vapor

enum LocationMigrations {
    struct v1: AsyncMigration {
        func prepare(on db: Database) async throws {
            try await db.schema(LocationModel.schema)
                .id()
                .field(LocationModel.FieldKeys.v1.address, .string, .required)
                .field(LocationModel.FieldKeys.v1.city, .string, .required)
                .field(LocationModel.FieldKeys.v1.zipcode, .string, .required)
                .field(LocationModel.FieldKeys.v1.longitude, .double, .required)
                .field(LocationModel.FieldKeys.v1.latitude, .double, .required)
                .field(LocationModel.FieldKeys.v1.businessId, .uuid, .required)
                .foreignKey(
                    LocationModel.FieldKeys.v1.businessId,
                    references: BusinessAccountModel.schema, .id
                )
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(LocationModel.schema).delete()
        }
    }
}

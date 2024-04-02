import Common
import Fluent
import Vapor

enum BusinessMigrations {
    
    struct v1: AsyncMigration {
        
        func prepare(on db: Database) async throws {
            try await db.schema(BusinessAccountModel.schema)
                .id()
                .field(BusinessAccountModel.FieldKeys.v1.name, .string, .required)
                .field(BusinessAccountModel.FieldKeys.v1.industry, .string, .required)
                .field(BusinessAccountModel.FieldKeys.v1.website, .string)
                .field(BusinessAccountModel.FieldKeys.v1.contactPhone, .string, .required)
                .field(BusinessAccountModel.FieldKeys.v1.contactEmail, .string, .required)
                .field(BusinessAccountModel.FieldKeys.v1.description, .string, .required)
                .field(BusinessAccountModel.FieldKeys.v1.photoIds, .array(of: .uuid), .required)
                .field(BusinessAccountModel.FieldKeys.v1.isVerified, .bool, .required)
                .field(BusinessAccountModel.FieldKeys.v1.avatarId, .uuid, .required)
                .field(BusinessAccountModel.FieldKeys.v1.userId, .uuid, .required)
                .foreignKey(
                    BusinessAccountModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id
                )
                .unique(on: BusinessAccountModel.FieldKeys.v1.name)
                .create()
        }

        func revert(on db: Database) async throws  {
            try await db.schema(UserAccountModel.schema).delete()
        }
    }
}

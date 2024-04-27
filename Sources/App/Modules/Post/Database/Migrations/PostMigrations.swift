import Common
import Fluent
import Vapor

enum PostMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(PostModel.schema)
                .id()
                .field(PostModel.FieldKeys.v1.imageIDs, .array(of: .string))
                .field(PostModel.FieldKeys.v1.videoIDs, .array(of: .string))
                .field(PostModel.FieldKeys.v1.tags, .array(of: .string), .required)
                .field(PostModel.FieldKeys.v1.text, .string, .required)
                .field(PostModel.FieldKeys.v1.userId, .uuid, .required)
                .field(PostModel.FieldKeys.v1.createdAt, .datetime)
                .field(PostModel.FieldKeys.v1.updatedAt, .datetime)
                .field(PostModel.FieldKeys.v1.deletedAt, .datetime)
                .foreignKey(
                    PostModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id
                )
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(PostModel.schema).delete()
        }
    }
}

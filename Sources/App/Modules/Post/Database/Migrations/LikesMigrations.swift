import Common
import Fluent
import Vapor

enum LikesMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(LikeModel.schema)
                .id()
                .field(LikeModel.FieldKeys.v1.userId, .uuid, .required)
                .foreignKey(
                    LikeModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id,
                    onDelete: .cascade
                )
                .field(LikeModel.FieldKeys.v1.postId, .uuid, .required)
                .foreignKey(
                    LikeModel.FieldKeys.v1.postId,
                    references: PostModel.schema, .id,
                    onDelete: .cascade
                )
                .field(LikeModel.FieldKeys.v1.createdAt, .datetime)
                .field(LikeModel.FieldKeys.v1.updatedAt, .datetime)
                .field(LikeModel.FieldKeys.v1.deletedAt, .datetime)
                .unique(on: LikeModel.FieldKeys.v1.postId, LikeModel.FieldKeys.v1.userId)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(LikeModel.schema).delete()
        }
    }
}

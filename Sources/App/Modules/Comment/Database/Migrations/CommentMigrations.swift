import Common
import Fluent
import Vapor

enum CommentMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(CommentModel.schema)
                .id()
                .field(CommentModel.FieldKeys.v1.text, .string)
                .field(CommentModel.FieldKeys.v1.parentCommentId, .uuid)
                .field(CommentModel.FieldKeys.v1.createdAt, .datetime)
                .field(CommentModel.FieldKeys.v1.updatedAt, .datetime)
                .field(CommentModel.FieldKeys.v1.deletedAt, .datetime)
                .field(CommentModel.FieldKeys.v1.parentCommentId, .uuid)
                .foreignKey(
                    CommentModel.FieldKeys.v1.parentCommentId,
                    references: CommentModel.schema, .id,
                    onDelete: .cascade
                )
                .field(CommentModel.FieldKeys.v1.userId, .uuid, .required)
                .foreignKey(
                    CommentModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id,
                    onDelete: .cascade
                )
                .field(CommentModel.FieldKeys.v1.postId, .uuid, .required)
                .foreignKey(
                    CommentModel.FieldKeys.v1.postId,
                    references: PostModel.schema, .id,
                    onDelete: .cascade
                )
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(CommentModel.schema).delete()
        }
    }
}

import Common
import Fluent
import Vapor

enum UserFollowerMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(UserFollowerModel.schema)
                .id()
                .field(UserFollowerModel.FieldKeys.v1.userId, .uuid, .required)
                .foreignKey(
                    UserFollowerModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id
                )
                .field(UserFollowerModel.FieldKeys.v1.followerId, .uuid, .required)
                .foreignKey(
                    UserFollowerModel.FieldKeys.v1.followerId,
                    references: UserAccountModel.schema, .id
                )
                .field(UserFollowerModel.FieldKeys.v1.createdAt, .datetime)
                .field(UserFollowerModel.FieldKeys.v1.updatedAt, .datetime)
                .field(UserFollowerModel.FieldKeys.v1.deletedAt, .datetime)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(UserFollowerModel.schema).delete()
        }
    }
}


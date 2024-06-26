import Vapor
import Fluent

enum AuthMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(RefreshTokenModel.schema)
                .id()
                .field(RefreshTokenModel.FieldKeys.v1.value, .string, .required)
                .field(RefreshTokenModel.FieldKeys.v1.expiresAt, .datetime, .required)
                .field(RefreshTokenModel.FieldKeys.v1.userId, .uuid, .required)
                .field(RefreshTokenModel.FieldKeys.v1.createdAt, .datetime)
                .field(RefreshTokenModel.FieldKeys.v1.updatedAt, .datetime)
                .field(RefreshTokenModel.FieldKeys.v1.deletedAt, .datetime)
                .foreignKey(
                    RefreshTokenModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id,
                    onDelete: .cascade
                )
                .unique(on: RefreshTokenModel.FieldKeys.v1.value)
                .create()
            
            try await database.schema(EmailTokenModel.schema)
                .id()
                .field(EmailTokenModel.FieldKeys.v1.value, .string, .required)
                .field(EmailTokenModel.FieldKeys.v1.expiresAt, .datetime, .required)
                .field(EmailTokenModel.FieldKeys.v1.userId, .uuid, .required)
                .field(EmailTokenModel.FieldKeys.v1.createdAt, .datetime)
                .field(EmailTokenModel.FieldKeys.v1.updatedAt, .datetime)
                .field(EmailTokenModel.FieldKeys.v1.deletedAt, .datetime)
                .foreignKey(
                    EmailTokenModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id,
                    onDelete: .cascade
                )
                .unique(on: EmailTokenModel.FieldKeys.v1.value)
                .create()
            
            try await database.schema(PasswordTokenModel.schema)
                .id()
                .field(PasswordTokenModel.FieldKeys.v1.value, .string, .required)
                .field(PasswordTokenModel.FieldKeys.v1.expiresAt, .datetime, .required)
                .field(PasswordTokenModel.FieldKeys.v1.userId, .uuid, .required)
                .field(PasswordTokenModel.FieldKeys.v1.createdAt, .datetime)
                .field(PasswordTokenModel.FieldKeys.v1.updatedAt, .datetime)
                .field(PasswordTokenModel.FieldKeys.v1.deletedAt, .datetime)
                .foreignKey(
                    PasswordTokenModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id,
                    onDelete: .cascade
                )
                .unique(on: PasswordTokenModel.FieldKeys.v1.value)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(RefreshTokenModel.schema).delete()
            try await database.schema(EmailTokenModel.schema).delete()
            try await database.schema(PasswordTokenModel.schema).delete()
        }
    }
}

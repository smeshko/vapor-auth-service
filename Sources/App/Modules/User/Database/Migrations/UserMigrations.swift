import Common
import Fluent
import Vapor

enum UserMigrations {
    
    struct v1: AsyncMigration {
        
        func prepare(on db: Database) async throws {
            try await db.schema(UserAccountModel.schema)
                .id()
                .field(UserAccountModel.FieldKeys.v1.email, .string, .required)
                .field(UserAccountModel.FieldKeys.v1.password, .string)
                .field(UserAccountModel.FieldKeys.v1.firstName, .string)
                .field(UserAccountModel.FieldKeys.v1.lastName, .string)
                .field(UserAccountModel.FieldKeys.v1.appleUserIdentifier, .string)
                .field(UserAccountModel.FieldKeys.v1.isAdmin, .bool, .required)
                .field(UserAccountModel.FieldKeys.v1.isEmailVerified, .bool, .required)
                .field(UserAccountModel.FieldKeys.v1.avatar, .uuid)
                .unique(on: UserAccountModel.FieldKeys.v1.email)
                .create()
        }

        func revert(on db: Database) async throws  {
            try await db.schema(UserAccountModel.schema).delete()
        }
    }
    
    struct seed: AsyncMigration {
        
        func prepare(on db: Database) async throws {
            let email = "root@localhost.com"
            let password = "ChangeMe1"
            let user = UserAccountModel(
                email: email,
                password: try Bcrypt.hash(password),
                firstName: "John",
                lastName: "Doe",
                isAdmin: true,
                isEmailVerified: true
            )
            try await user.create(on: db)
        }

        func revert(on db: Database) async throws {
            try await UserAccountModel.query(on: db).delete()
        }
    }
}

import Common
import Fluent
import Vapor

private let tokenLifetime: TimeInterval = 1.hours

final class PasswordTokenModel: DatabaseModelInterface {
    typealias Module = AuthModule
    
    static var schema: String { "password_tokens" }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel

    @Field(key: FieldKeys.v1.value)
    var value: String
    
    @Field(key: FieldKeys.v1.expiresAt)
    var expiresAt: Date
    
    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}
    
    init(
        id: UUID? = nil,
        userID: UUID,
        value: String,
        expiresAt: Date = Date().addingTimeInterval(tokenLifetime)
    ) {
        self.id = id
        self.$user.id = userID
        self.value = value
        self.expiresAt = expiresAt
    }
}

extension PasswordTokenModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var value: FieldKey { "value" }
            static var expiresAt: FieldKey { "expires_at" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

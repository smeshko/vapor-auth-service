import Common
import Fluent
import Vapor

private let refreshTokenLifetime: TimeInterval = 7.days

final class RefreshTokenModel: DatabaseModelInterface {
    
    typealias Module = UserModule
    
    static var schema: String { "refresh_tokens" }
        
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.v1.value)
    var value: String
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel
    
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
        value: String,
        userID: UUID,
        expiresAt: Date = Date().addingTimeInterval(refreshTokenLifetime)
    ) {
        self.id = id
        self.value = value
        self.$user.id = userID
        self.expiresAt = expiresAt
    }
}

extension RefreshTokenModel {
    struct FieldKeys {
        struct v1 {
            static var value: FieldKey { "value" }
            static var userId: FieldKey { "user_id" }
            static var expiresAt: FieldKey { "expires_at" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

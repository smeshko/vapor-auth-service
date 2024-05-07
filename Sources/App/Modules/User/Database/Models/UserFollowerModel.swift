import Common
import Fluent
import Vapor

final class UserFollowerModel: DatabaseModelInterface {
    typealias Module = UserModule
    static var schema: String { "user_followers" }
    
    @ID()
    var id: UUID?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel
    
    @Parent(key: FieldKeys.v1.followerId)
    var follower: UserAccountModel

    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?
}

extension UserFollowerModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var followerId: FieldKey { "follower_id" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}


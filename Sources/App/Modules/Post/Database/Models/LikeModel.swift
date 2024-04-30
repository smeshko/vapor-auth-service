import Common
import Fluent
import Vapor

final class LikeModel: DatabaseModelInterface {
    typealias Module = PostModule
    static var schema: String { "likes" }
    
    @ID()
    var id: UUID?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel

    @Parent(key: FieldKeys.v1.postId)
    var post: PostModel

    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?

}

extension LikeModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var postId: FieldKey { "post_id" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

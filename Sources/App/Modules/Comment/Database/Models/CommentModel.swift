import Common
import Fluent
import Vapor

final class CommentModel: DatabaseModelInterface {
    typealias Module = CommentModule
    static var schema: String { "comments" }
    
    @ID()
    var id: UUID?
    
    @OptionalParent(key: FieldKeys.v1.parentCommentId)
    var parentComment: CommentModel?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel
    
    @Parent(key: FieldKeys.v1.postId)
    var post: PostModel
    
    @Children(for: \.$parentComment)
    var childComments: [CommentModel]
    
    @Field(key: FieldKeys.v1.text)
    var text: String

    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}
    
    init(
        id: UUID? = nil,
        parentCommentID: UUID? = nil,
        userId: UUID,
        postId: UUID,
        text: String
    ) {
        self.id = id
        self.$parentComment.id = parentCommentID
        self.$user.id = userId
        self.$post.id = postId
        self.text = text
    }
}

extension CommentModel {
    struct FieldKeys {
        struct v1 {
            static var parentCommentId: FieldKey { "parent_comment_id" }
            static var userId: FieldKey { "user_id" }
            static var postId: FieldKey { "post_id" }
            static var text: FieldKey { "text" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

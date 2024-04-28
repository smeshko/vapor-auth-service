import Entities
import Vapor

extension Comment.Create.Response: Content {}
extension Comment.List.Response: Content {}
extension Comment.Reply.Response: Content {}

extension Comment.Create.Response {
    init(
        from model: CommentModel
    ) throws {
        try self.init(
            id: model.requireID(),
            createdAt: model.createdAt ?? .now,
            text: model.text,
            postID: model.$post.id,
            userID: model.$user.id
        )
    }
}

extension Comment.Reply.Response {
    init(
        from model: CommentModel
    ) throws {
        guard let parentId = model.$parentComment.id else {
            throw ContentError.parentCommentNotFound
        }
        try self.init(
            id: model.requireID(),
            text: model.text, 
            parentId: parentId,
            postID: model.$post.id,
            userID: model.$user.id
        )
    }
}

extension Comment.List.Response {
    init(from model: CommentModel) throws {
        try self.init(
            id: model.requireID(),
            createdAt: model.createdAt ?? .now,
            text: model.text,
            postID: model.$post.id,
            user: .init(from: model.user)
        )
    }
}

import Entities
import Vapor

extension Comment.Create.Response: Content {}
extension Comment.Reply.Response: Content {}

extension Comment.Create.Response {
    init(
        from model: CommentModel
    ) throws {
        try self.init(
            id: model.requireID(),
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
        guard let parentId = try model.parentComment?.requireID() else {
            throw Abort(.badRequest)
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

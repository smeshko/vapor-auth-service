import Common
import Entities
import Fluent
import Vapor

struct CommentController {
    func post(_ req: Request) async throws -> Comment.Create.Response {
        let input = try req.content.decode(Comment.Create.Request.self)
        let user = try req.auth.require(UserAccountModel.self)
        let postId = try req.parameters.require("postID", as: UUID.self)
        
        let model = try CommentModel(
            userId: user.requireID(),
            postId: postId,
            text: input.text
        )
        
        try await req.repositories.comments.create(model)
        return try .init(from: model)
    }
    
    func reply(_ req: Request) async throws -> Comment.Reply.Response {
        let input = try req.content.decode(Comment.Reply.Request.self)
        let user = try req.auth.require(UserAccountModel.self)
        let commentId = try req.parameters.require("commentID", as: UUID.self)
        
        guard let parentComment = try await req.repositories.comments.find(id: commentId) else {
            throw ContentError.contentNotFound
        }

        let model = try CommentModel(
            parentCommentID: commentId,
            userId: user.requireID(),
            postId: parentComment.$post.id,
            text: input.text
        )
        
        try await req.repositories.comments.create(model)
        return try .init(from: model)
    }
}

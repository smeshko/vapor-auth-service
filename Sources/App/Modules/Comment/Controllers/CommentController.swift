import Common
import Entities
import Fluent
import Vapor

struct CommentController {
    func post(_ req: Request) async throws -> [Comment.List.Response] {
        let input = try req.content.decode(Comment.Create.Request.self)
        let user = try req.auth.require(UserAccountModel.self)
        let postId = try req.parameters.require("postID", as: UUID.self)
        
        guard let post = try await req.repositories.posts.find(id: postId) else {
            throw ContentError.postNotFound
        }
        
        let model = try CommentModel(
            userId: user.requireID(),
            postId: postId,
            text: input.text
        )
        
        try await req.repositories.comments.create(model)
        
        return try await req.repositories.comments
            .all(forPostId: post.requireID())
            .map(Comment.List.Response.init(from:))
    }
    
    func allForPost(_ req: Request) async throws -> [Comment.List.Response] {
        let postId = try req.parameters.require("postID", as: UUID.self)

        guard let post = try await req.repositories.posts.find(id: postId) else {
            throw ContentError.postNotFound
        }

        return try post.comments.map(Comment.List.Response.init(from:))
    }
    
    func reply(_ req: Request) async throws -> Comment.Reply.Response {
        let input = try req.content.decode(Comment.Reply.Request.self)
        let user = try req.auth.require(UserAccountModel.self)
        let commentId = try req.parameters.require("commentID", as: UUID.self)
        
        guard let parentComment = try await req.repositories.comments.find(id: commentId) else {
            throw ContentError.parentCommentNotFound
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

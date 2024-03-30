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
        
        try await req.comments.create(model)
        return try .init(from: model)
    }
    
    func reply(_ req: Request) async throws -> Comment.Reply.Response {
        let input = try req.content.decode(Comment.Reply.Request.self)
        let user = try req.auth.require(UserAccountModel.self)
        let commentId = try req.parameters.require("commentID", as: UUID.self)
        
        guard let parentComment = try await req.comments.find(id: commentId) else {
            throw Abort(.notFound)
        }

        let model = try CommentModel(
            parentCommentID: commentId,
            userId: user.requireID(),
            postId: parentComment.$post.id,
            text: input.text
        )
        
        try await req.comments.create(model)
        return try .init(from: model)
    }
}

public enum Comment {}

extension Comment {
    enum Create {
        public struct Request: Codable, Equatable {
            public let text: String
            
            init(
                text: String
            ) {
                self.text = text
            }
        }
        
        public struct Response: Codable, Equatable {
            public let id: UUID
            public let text: String
            public let postID: UUID
            public let userID: UUID
            
            public init(
                id: UUID,
                text: String,
                postID: UUID,
                userID: UUID
            ) {
                self.id = id
                self.text = text
                self.postID = postID
                self.userID = userID
            }
        }
    }
    
    enum Reply {
        public struct Request: Codable, Equatable {
            public let text: String
            
            init(
                text: String
            ) {
                self.text = text
            }
        }
        
        public struct Response: Codable, Equatable {
            public let id: UUID
            public let text: String
            public let parentId: UUID
            public let postID: UUID
            public let userID: UUID
            
            public init(
                id: UUID,
                text: String,
                parentId: UUID,
                postID: UUID,
                userID: UUID
            ) {
                self.id = id
                self.text = text
                self.parentId = parentId
                self.postID = postID
                self.userID = userID
            }
        }
    }
}

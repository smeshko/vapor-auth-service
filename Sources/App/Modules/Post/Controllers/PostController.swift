import Common
import Entities
import Fluent
import Vapor

struct PostController {
    func like(_ req: Request) async throws -> Post.Detail.Response {
        let user = try req.auth.require(UserAccountModel.self)
        let postId = try req.parameters.require("postID", as: UUID.self)

        guard let post = try await req.repositories.posts.find(id: postId) else {
            throw ContentError.postNotFound
        }

        try await req.repositories.posts.user(user, likes: post)
        
        return try Post.Detail.Response(from: post)
    }
    
    func create(_ req: Request) async throws -> Post.Create.Response {
        let user = try req.auth.require(UserAccountModel.self)
        let request = try req.content.decode(Post.Create.Request.self)
        
        let postModel = try PostModel(
            user: user,
            imageIDs: request.imageIDs,
            videoIDs: request.videoIDs,
            category: request.category.rawValue,
            text: request.text,
            title: request.title,
            tags: request.tags.map(\.rawValue)
        )
        
        try await req.repositories.posts.create(postModel)
        
        return try Post.Create.Response(from: postModel)
    }
    
    func details(_ req: Request) async throws -> Post.Detail.Response {
        let postId = try req.parameters.require("postID", as: UUID.self)
        
        guard let post = try await req.repositories.posts.find(id: postId) else {
            throw ContentError.postNotFound
        }
        
        return try .init(from: post)
    }
    
    func all(_ req: Request) async throws -> [Post.List.Response] {
        let category = try req.query.get(String?.self, at: "category")
        let tag = try req.query.get(String?.self, at: "tag")

        return try await req.repositories.posts
            .all(tag: tag, category: category)
            .map(Post.List.Response.init(from:))
    }
    
    func userPosts(_ req: Request) async throws -> [Post.List.Response] {
        let userId = try req.parameters.require("userID", as: UUID.self)

        return try await req.repositories.posts
            .all(forUserId: userId)
            .map(Post.List.Response.init(from:))
    }
}

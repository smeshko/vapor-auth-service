import Common
import Entities
import Fluent
import Vapor

struct PostController {
    func create(_ req: Request) async throws -> Post.Create.Response {
        let user = try req.auth.require(UserAccountModel.self)
        let request = try req.content.decode(Post.Create.Request.self)
        let postModel = try PostModel(
            user: user,
            images: nil,
            videos: nil,
            text: request.text,
            tags: []
        )
        
        try await req.posts.create(postModel)
        
        return Post.Create.Response(from: postModel)
    }
    
    func all(_ req: Request) async throws -> [Post.List.Response] {
        try await req.posts.all().map(Post.List.Response.init(from:))
    }
    
    func userPosts(_ req: Request) async throws -> [Post.List.Response] {
        let userId = try req.parameters.require("userID", as: UUID.self)

        return try await req.posts
            .all(forUserId: userId)
            .map(Post.List.Response.init(from:))
    }
}

public enum Post {}

public extension Post {
    enum Create {
        public struct Request: Codable, Equatable {
            public let text: String
            
            public init(text: String) {
                self.text = text
            }
        }
        
        public struct Response: Codable, Equatable {
            public let text: String
            
            public init(text: String) {
                self.text = text
            }
        }
    }
    
    enum List {
        public struct Request: Codable, Equatable {
            
            public init() {}
        }
        
        public struct Response: Codable, Equatable {
            public let text: String
            public let imageURLs: [String]
            public let videoURLs: [String]
            public let tags: [String]
            
            public init(
                text: String,
                imageURLs: [String],
                videoURLs: [String],
                tags: [String]
            ) {
                self.text = text
                self.imageURLs = imageURLs
                self.videoURLs = videoURLs
                self.tags = tags
            }
        }
    }
}

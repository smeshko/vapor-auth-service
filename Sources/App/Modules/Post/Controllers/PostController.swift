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
            imageIDs: request.imageIDs,
            videoIDs: request.videoIDs,
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
public enum Media {}

public extension Post {
    enum Create {
        public struct Request: Codable, Equatable {
            public let text: String
            public let imageIDs: [UUID]
            public let videoIDs: [UUID]
            
            public init(
                text: String,
                imageIDs: [UUID],
                videoIDs: [UUID]
            ) {
                self.text = text
                self.imageIDs = imageIDs
                self.videoIDs = videoIDs
            }
        }
        
        public struct Response: Codable, Equatable {
            public let text: String
            public let imageIDs: [UUID]
            public let videoIDs: [UUID]
            
            public init(
                text: String,
                imageIDs: [UUID],
                videoIDs: [UUID]
            ) {
                self.text = text
                self.imageIDs = imageIDs
                self.videoIDs = videoIDs
            }
        }
    }
    
    enum List {
        public struct Request: Codable, Equatable {
            
            public init() {}
        }
        
        public struct Response: Codable, Equatable {
            public let text: String
            public let imageIDs: [UUID]
            public let videoIDs: [UUID]
            public let tags: [String]
            
            public init(
                text: String,
                imageIDs: [UUID],
                videoIDs: [UUID],
                tags: [String]
            ) {
                self.text = text
                self.imageIDs = imageIDs
                self.videoIDs = videoIDs
                self.tags = tags
            }
        }
    }
}

public extension Media {
    enum `Type`: String, Codable, Equatable {
        case photo, video
    }
    
    enum Upload {
        public struct Request: Codable, Equatable {
            public let data: Data
            public let ext: String
            public let type: `Type`
            
            public init(
                data: Data,
                ext: String,
                type: `Type`
            ) {
                self.data = data
                self.ext = ext
                self.type = type
            }
        }
        
        public struct Response: Codable, Equatable {
            public let id: UUID
            public let type: `Type`

            public init(
                id: UUID,
                type: `Type`
            ) {
                self.id = id
                self.type = type
            }
        }
    }
    
    enum Download {
        public struct Request: Codable, Equatable {
            public let id: UUID
        }
        
        public struct Response: Codable, Equatable {
            public let data: Data
        }
    }
}

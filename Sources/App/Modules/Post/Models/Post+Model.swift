import Common
import Entities
import Vapor

extension Post.List.Response: Content {}
extension Post.Create.Response: Content {}
extension Post.Detail.Response: Content {}
extension Media.Upload.Response: Content {}

extension Post.Create.Response {
    init(
        from model: PostModel
    ) throws {
        try self.init(
            id: model.requireID(),
            createdAt: model.createdAt ?? .now,
            text: model.text,
            imageIDs: model.imageIDs ?? [],
            videoIDs: model.videoIDs ?? []
        )
    }
}

extension Post.List.Response {
    init(
        from model: PostModel
    ) throws {
        guard let firstImage = model.imageIDs?.first else {
            throw ContentError.postContainsNoImages
        }
        try self.init(
            id: model.requireID(),
            createdAt: model.createdAt ?? .now,
            text: model.text,
            thumbnail: firstImage,
            user: .init(from: model.user), 
            likes: model.likedBy.count,
            commentCount: model.comments.count,
            tags: model.tags
        )
    }
}

extension Post.Detail.Response {
    init(
        from model: PostModel
    ) throws {
        try self.init(
            id: model.requireID(),
            createdAt: model.createdAt ?? .now,
            user: .init(from: model.user),
            comments: model.comments.map(Comment.List.Response.init(from:)),
            text: model.text,
            likes: model.likedBy.count,
            imageIDs: model.imageIDs ?? [],
            videoIDs: model.videoIDs ?? [],
            tags: model.tags
        )
    }
}

import Common
import Entities
import Vapor

extension Post.List.Response: Content {}
extension Post.Create.Response: Content {}
extension Media.Upload.Response: Content {}

extension Post.Create.Response {
    init(
        from model: PostModel
    ) {
        self.init(
            text: model.text,
            imageIDs: model.imageIDs ?? [],
            videoIDs: model.videoIDs ?? []
        )
    }
}

extension Post.List.Response {
    init(
        from model: PostModel
    ) {
        self.init(
            text: model.text,
            imageIDs: model.imageIDs ?? [],
            videoIDs: model.videoIDs ?? [],
            tags: model.tags
        )
    }
}

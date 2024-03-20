import Common
import Entities
import Vapor

extension Post.List.Response: Content {}
extension Post.Create.Response: Content {}

extension Post.Create.Response {
    init(
        from model: PostModel
    ) {
        self.init(text: model.text)
    }
}

extension Post.List.Response {
    init(
        from model: PostModel
    ) {
        self.init(
            text: model.text,
            imageURLs: model.images ?? [],
            videoURLs: model.videos ?? [],
            tags: model.tags
        )
    }
}

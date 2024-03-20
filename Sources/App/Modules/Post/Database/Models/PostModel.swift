import Common
import Fluent
import Vapor

final class PostModel: DatabaseModelInterface {
    typealias Module = PostModule
    static var schema: String { "posts" }
    
    @ID()
    var id: UUID?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel

    @OptionalField(key: FieldKeys.v1.imageURLs)
    var images: [String]?
    
    @OptionalField(key: FieldKeys.v1.videoURLs)
    var videos: [String]?
    
    @Field(key: FieldKeys.v1.tags)
    var tags: [String]
    
    @Field(key: FieldKeys.v1.text)
    var text: String
    
    init() {}
    
    init(
        id: UUID? = nil,
        user: UserAccountModel,
        images: [String]? = nil,
        videos: [String]? = nil,
        text: String,
        tags: [String] = []
    ) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.images = images
        self.videos = videos
        self.text = text
        self.tags = tags
    }
}

extension PostModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var imageURLs: FieldKey { "image_urls" }
            static var videoURLs: FieldKey { "video_urls" }
            static var text: FieldKey { "test" }
            static var tags: FieldKey { "tags" }
        }
    }
}

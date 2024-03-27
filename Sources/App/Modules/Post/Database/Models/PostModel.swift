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

    @OptionalField(key: FieldKeys.v1.imageIDs)
    var imageIDs: [UUID]?
    
    @OptionalField(key: FieldKeys.v1.videoIDs)
    var videoIDs: [UUID]?
    
    @Field(key: FieldKeys.v1.tags)
    var tags: [String]
    
    @Field(key: FieldKeys.v1.text)
    var text: String
    
    init() {}
    
    init(
        id: UUID? = nil,
        user: UserAccountModel,
        imageIDs: [UUID]? = nil,
        videoIDs: [UUID]? = nil,
        text: String,
        tags: [String] = []
    ) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.imageIDs = imageIDs
        self.videoIDs = videoIDs
        self.text = text
        self.tags = tags
    }
}

extension PostModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var imageIDs: FieldKey { "image_ids" }
            static var videoIDs: FieldKey { "video_ids" }
            static var text: FieldKey { "test" }
            static var tags: FieldKey { "tags" }
        }
    }
}

import Common
import Fluent
import Vapor

final class MediaModel: DatabaseModelInterface {
    typealias Module = MediaModule
    static var schema: String { "media" }
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.v1.type)
    var type: String

    @Field(key: FieldKeys.v1.ext)
    var ext: String
    
    @Field(key: FieldKeys.v1.key)
    var key: String
    
    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}
    
    init(
        id: UUID? = nil,
        type: String,
        ext: String,
        key: String
    ) {
        self.id = id
        self.type = type
        self.ext = ext
        self.key = key
    }
}

extension MediaModel {
    struct FieldKeys {
        struct v1 {
            static var type: FieldKey { "type" }
            static var ext: FieldKey { "extension" }
            static var key: FieldKey { "key" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

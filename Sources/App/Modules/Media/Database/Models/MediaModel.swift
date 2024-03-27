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
        }
    }
}

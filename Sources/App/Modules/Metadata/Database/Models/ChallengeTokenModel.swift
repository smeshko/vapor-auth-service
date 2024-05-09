import Common
import Fluent
import Vapor

final class ChallengeTokenModel: DatabaseModelInterface {
    
    typealias Module = MetadataModule
    
    static var schema: String { "challenge_tokens" }
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.v1.value)
    var value: String
    
    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        value: String
    ) {
        self.id = id
        self.value = value
    }
}

extension ChallengeTokenModel {
    struct FieldKeys {
        struct v1 {
            static var value: FieldKey { "value" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

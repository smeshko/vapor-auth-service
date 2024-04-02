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
        }
    }
}

import Common
import Fluent
import Vapor

final class BusinessModel: DatabaseModelInterface {
    typealias Module = BusinessModule
    static var schema: String { "businesses" }
    
    @ID()
    var id: UUID?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel

    @Field(key: FieldKeys.v1.latitude)
    var latitude: Double
    
    @Field(key: FieldKeys.v1.longitude)
    var videos: [String]?
    
    
}

extension BusinessModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var longitude: FieldKey { "longitude" }
            static var latitude: FieldKey { "latitude" }
            static var name: FieldKey { "name" }
        }
    }
}

import Common
import Fluent
import Vapor

final class UserAccountModel: DatabaseModelInterface, Authenticatable {
    typealias Module = UserModule
    static var schema: String { "users" }
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.v1.email)
    var email: String
    
    @Field(key: FieldKeys.v1.password)
    var password: String
    
    @Field(key: FieldKeys.v1.fullName)
    var fullName: String
    
    @Field(key: FieldKeys.v1.isAdmin)
    var isAdmin: Bool
    
    @Field(key: FieldKeys.v1.isEmailVerified)
    var isEmailVerified: Bool
    
    @Children(for: \.$user)
    var posts: [PostModel]

    init() { }
    
    init(
        id: UUID? = nil,
        email: String,
        password: String,
        fullName: String,
        isAdmin: Bool = false,
        isEmailVerified: Bool = false
    ) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.isAdmin = isAdmin
        self.isEmailVerified = isEmailVerified
        self.password = password
    }
}

extension UserAccountModel {
    struct FieldKeys {
        struct v1 {
            static var email: FieldKey { "email" }
            static var password: FieldKey { "password" }
            static var isAdmin: FieldKey { "is_admin" }
            static var isEmailVerified: FieldKey { "is_email_verified" }
            static var fullName: FieldKey { "full_name" }
        }
    }
}

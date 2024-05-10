import Common
import Entities
import Fluent
import Vapor

final class UserAccountModel: DatabaseModelInterface, Authenticatable {
    typealias Module = UserModule
    static var schema: String { "users" }
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.v1.email)
    var email: String
    
    @OptionalField(key: FieldKeys.v1.password)
    var password: String?
    
    @Field(key: FieldKeys.v1.isAdmin)
    var isAdmin: Bool
    
    @OptionalChild(for: \.$user)
    var location: LocationModel?

    @OptionalField(key: FieldKeys.v1.firstName)
    var firstName: String?

    @OptionalField(key: FieldKeys.v1.lastName)
    var lastName: String?

    @OptionalField(key: FieldKeys.v1.appleUserIdentifier)
    var appleUserIdentifier: String?

    @Field(key: FieldKeys.v1.isEmailVerified)
    var isEmailVerified: Bool
    
    @OptionalField(key: FieldKeys.v1.avatar)
    var avatar: UUID?
    
    @Siblings(through: LikeModel.self, from: \.$user, to: \.$post)
    var likes: [PostModel]
    
    @Children(for: \.$user)
    var posts: [PostModel]
    
    @Children(for: \.$user)
    var comments: [CommentModel]
    
    @Siblings(through: UserFollowerModel.self, from: \.$user, to: \.$follower)
    var followers: [UserAccountModel]
    
    @Siblings(through: UserFollowerModel.self, from: \.$follower, to: \.$user)
    var following: [UserAccountModel]

    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?

    init() { }
    
    init(
        id: UUID? = nil,
        email: String,
        password: String?,
        firstName: String? = nil,
        lastName: String? = nil,
        appleUserIdentifier: String? = nil,
        avatar: UUID? = nil,
        isAdmin: Bool = false,
        isEmailVerified: Bool = false
    ) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.appleUserIdentifier = appleUserIdentifier
        self.avatar = avatar
        self.isAdmin = isAdmin
        self.isEmailVerified = isEmailVerified
        self.password = password
        self.$followers.value = []
        self.$following.value = []
    }
}

extension UserAccountModel {
    struct FieldKeys {
        struct v1 {
            static var email: FieldKey { "email" }
            static var password: FieldKey { "password" }
            static var isAdmin: FieldKey { "is_admin" }
            static var isEmailVerified: FieldKey { "is_email_verified" }
            static var firstName: FieldKey { "first_name" }
            static var lastName: FieldKey { "last_name" }
            static var avatar: FieldKey { "avatar" }
            static var appleUserIdentifier: FieldKey { "apple_user_identifier" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

extension UserAccountModel {
    static func `guard`() -> Middleware {
        UserAccountModel.guardMiddleware(throwing: UserError.userNotFound)
    }
}

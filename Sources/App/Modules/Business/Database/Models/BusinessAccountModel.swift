import Common
import Fluent
import Vapor

final class BusinessAccountModel: DatabaseModelInterface {
    typealias Module = BusinessModule
    static var schema: String { "businesses" }
    
    @ID()
    var id: UUID?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel

    @Children(for: \.$business)
    var openingHours: [OpeningHoursModel]
    
    @OptionalChild(for: \.$business)
    var location: LocationModel?

    @Field(key: FieldKeys.v1.name)
    var name: String 
    
    @Field(key: FieldKeys.v1.industry)
    var industry: String 
    
    @OptionalField(key: FieldKeys.v1.website)
    var website: String?
    
    @Field(key: FieldKeys.v1.contactPhone)
    var contactPhone: String 
    
    @Field(key: FieldKeys.v1.contactEmail)
    var contactEmail: String
    
    @Field(key: FieldKeys.v1.description)
    var description: String 
    
    @Field(key: FieldKeys.v1.photoIds)
    var photoIds: [String]
    
    @Field(key: FieldKeys.v1.isVerified)
    var isVerified: Bool
    
    @Field(key: FieldKeys.v1.avatarId)
    var avatarId: UUID
    
    init() {}
    
    init(
        id: UUID? = nil,
        user: UserAccountModel,
        openingHours: [OpeningHoursModel],
        name: String,
        industry: String,
        website: String? = nil,
        contactPhone: String,
        contactEmail: String,
        description: String,
        photoIds: [String],
        isVerified: Bool,
        avatarId: UUID
    ) {
        self.id = id
        self.user = user
        self.openingHours = openingHours
        self.name = name
        self.industry = industry
        self.website = website
        self.contactPhone = contactPhone
        self.contactEmail = contactEmail
        self.description = description
        self.photoIds = photoIds
        self.isVerified = isVerified
        self.avatarId = avatarId
    }
}

extension BusinessAccountModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var name: FieldKey { "name" }
            static var industry: FieldKey { "industry" }
            static var website: FieldKey { "website" }
            static var contactPhone: FieldKey { "contact_phone" }
            static var contactEmail: FieldKey { "contact_email" }
            static var description: FieldKey { "description" }
            static var photoIds: FieldKey { "photo_ids" }
            static var isVerified: FieldKey { "is_verified" }
            static var avatarId: FieldKey { "avatar_id" }
        }
    }
}

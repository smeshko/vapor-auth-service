import Common
import Fluent
import Vapor

final class LocationModel: DatabaseModelInterface {
    typealias Module = UserModule
    static let schema = "locations"
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.v1.address)
    var address: String
    
    @Field(key: FieldKeys.v1.city)
    var city: String
    
    @Field(key: FieldKeys.v1.zipcode)
    var zipcode: String
    
    @Field(key: FieldKeys.v1.longitude)
    var longitude: Double
    
    @Field(key: FieldKeys.v1.latitude)
    var latitude: Double
    
    @OptionalField(key: FieldKeys.v1.radius)
    var radius: Double?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel
    
    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}
    
    init(
        id: UUID? = nil,
        address: String,
        city: String,
        zipcode: String,
        longitude: Double,
        latitude: Double,
        radius: Double? = nil,
        userId: UUID
    ) {
        self.id = id
        self.address = address
        self.city = city
        self.zipcode = zipcode
        self.longitude = longitude
        self.latitude = latitude
        self.radius = radius
        self.$user.id = userId
    }
}

extension LocationModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var address: FieldKey { "address" }
            static var city: FieldKey { "city" }
            static var zipcode: FieldKey { "zipcode" }
            static var longitude: FieldKey { "longitude" }
            static var latitude: FieldKey { "latitude" }
            static var radius: FieldKey { "radius" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

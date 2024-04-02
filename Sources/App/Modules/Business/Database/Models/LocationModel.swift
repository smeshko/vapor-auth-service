import Common
import Fluent
import Vapor

final class LocationModel: DatabaseModelInterface {
    typealias Module = BusinessModule
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
    
    @Parent(key: FieldKeys.v1.businessId)
    var business: BusinessAccountModel
    
    init() { }
    
    init(
        id: UUID? = nil,
        address: String,
        city: String,
        zipcode: String,
        longitude: Double,
        latitude: Double,
        businessId: UUID
    ) {
        self.id = id
        self.address = address
        self.city = city
        self.zipcode = zipcode
        self.longitude = longitude
        self.latitude = latitude
        self.$business.id = businessId
    }
}

extension LocationModel {
    struct FieldKeys {
        struct v1 {
            static var businessId: FieldKey { "business_id" }
            static var address: FieldKey { "address" }
            static var city: FieldKey { "city" }
            static var zipcode: FieldKey { "zipcode" }
            static var longitude: FieldKey { "longitude" }
            static var latitude: FieldKey { "latitude" }
        }
    }
}

import Common
import Fluent
import Vapor

final class OpeningHoursModel: DatabaseModelInterface {
    typealias Module = BusinessModule
    static let schema = "opening_hours"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.v1.day)
    var day: String
    
    @Field(key: FieldKeys.v1.openingTime)
    var openingTime: String
    
    @Field(key: FieldKeys.v1.closingTime)
    var closingTime: String
    
    @Parent(key: FieldKeys.v1.businessId)
    var business: BusinessAccountModel

    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?

    init() { }
    
    init(
        id: UUID? = nil,
        day: String,
        openingTime: String,
        closingTime: String,
        businessID: UUID
    ) {
        self.id = id
        self.day = day
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.$business.id = businessID
    }
}

extension OpeningHoursModel {
    struct FieldKeys {
        struct v1 {
            static var businessId: FieldKey { "business_id" }
            static var day: FieldKey { "day" }
            static var openingTime: FieldKey { "opening_time" }
            static var closingTime: FieldKey { "closing_time" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

import Common
import Fluent
import Vapor

final class DeviceModel: DatabaseModelInterface {
    typealias Module = UserModule
    static var schema: String { "devices" }
    
    @ID()
    var id: UUID?
    
    @Parent(key: FieldKeys.v1.userId)
    var user: UserAccountModel
    
    @Field(key: FieldKeys.v1.system)
    var system: String

    @Field(key: FieldKeys.v1.osVersion)
    var osVersion: String

    @OptionalField(key: FieldKeys.v1.pushToken)
    var pushToken: String?
    
    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        userId: UUID,
        system: String,
        osVersion: String,
        pushToken: String? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.$user.id = userId
        self.system = system
        self.osVersion = osVersion
        self.pushToken = pushToken
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}

extension DeviceModel {
    struct FieldKeys {
        struct v1 {
            static var userId: FieldKey { "user_id" }
            static var system: FieldKey { "system" }
            static var osVersion: FieldKey { "os_version" }
            static var pushToken: FieldKey { "push_token" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}


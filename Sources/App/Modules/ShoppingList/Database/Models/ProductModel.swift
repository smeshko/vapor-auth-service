import Common
import Fluent
import Vapor

final class ProductModel: DatabaseModelInterface {
    typealias Module = ShoppingListModule
    static var schema: String { "products" }
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.v1.name)
    var name: String
    
    @Field(key: FieldKeys.v1.category)
    var category: String
    
    @Field(key: FieldKeys.v1.imageId)
    var imageId: UUID

    @Timestamp(key: FieldKeys.v1.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.v1.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.v1.deletedAt, on: .delete)
    var deletedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
    
}

extension ProductModel {
    struct FieldKeys {
        struct v1 {
            static var name: FieldKey { "name" }
            static var imageId: FieldKey { "image_id" }
            static var category: FieldKey { "category" }
            static var createdAt: FieldKey { "created_at" }
            static var updatedAt: FieldKey { "updated_at" }
            static var deletedAt: FieldKey { "deleted_at" }
        }
    }
}

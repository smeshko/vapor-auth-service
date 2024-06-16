import Entities
import Vapor

extension Product.List.Response: Content {}
extension ShoppingList.Add.Response: Content {}

extension Product.List.Response {
    init(from model: ProductModel) throws {
        try self.init(
            id: model.requireID(),
            name: model.name,
            category: .init(rawValue: model.category) ?? .fruit,
            imageId: model.imageId
        )
    }
}

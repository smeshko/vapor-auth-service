import Entities
import Vapor

struct ShoppingListController {
    func products(_ req: Request) async throws -> [Product.List.Response] {
        struct ProductItem: Codable {
            let name: String
            let category: String
            let imageId: UUID
        }
        
        if try await req.repositories.products.count() == 0 {
            let directory = req.application.directory.resourcesDirectory
            let data = try Data(contentsOf: URL(fileURLWithPath: directory)
                .appendingPathComponent("products.json", isDirectory: false))
            
            let products = try JSONDecoder().decode([ProductItem].self, from: data)
            try await products.asyncForEach { product in
                let model = ProductModel(
                    name: product.name,
                    category: product.category,
                    imageId: product.imageId
                )
                try await req.application.repositories.products.create(model)
            }
        }

        return try await req.repositories.products
            .all().map {
                try Product.List.Response(
                    id: $0.requireID(),
                    name: $0.name,
                    category: .init(rawValue: $0.category) ?? .fruit,
                    imageId: $0.imageId
                )
            }
    }
    
    func addProducts(_ req: Request) async throws -> ShoppingList.Add.Response {
        let user = try req.auth.require(UserAccountModel.self)
        let request = try req.content.decode(ShoppingList.Add.Request.self)
        
        if let list = try await req.repositories.shoppingLists.find(for: user, category: request.category.rawValue) {
            try await addProducts(request.products, to: list, on: req)
        } else {
            let list = try ShoppingListModel(userId: user.requireID(), category: request.category.rawValue)
            try await req.repositories.shoppingLists.create(list)
            try await addProducts(request.products, to: list, on: req)
        }
        
        let deals = try await req.repositories.shoppingLists
            .deals(for: user)?.items
            .map(\.product)
            .map(Product.List.Response.init(from:)) ?? []
        
        let premium = try await req.repositories.shoppingLists
            .premium(for: user)?.items
            .map(\.product)
            .map(Product.List.Response.init(from:)) ?? []

        return .init(deals: deals, premium: premium)
    }
}

private extension ShoppingListController {
    func addProducts(_ products: [UUID], to list: ShoppingListModel, on req: Request) async throws {
        try await products.asyncForEach { id in
            guard let product = try await req.repositories.products.find(id: id),
                    !list.items.contains(where: { $0.product.name == product.name }) else { return }
            
            let item = try ShoppingListItemModel(shoppingListId: list.requireID(), productId: product.requireID())
            try await req.repositories.shoppingLists.createItem(item)
        }
    }
}

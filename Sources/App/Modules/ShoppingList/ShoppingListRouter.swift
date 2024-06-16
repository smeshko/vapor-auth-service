import Vapor

struct ShoppingListRouter: RouteCollection {
    let controller = ShoppingListController()
    
    func boot(routes: any RoutesBuilder) throws {
        let listAPI = routes
            .grouped("api")
            .grouped("shopping-list")
        
        listAPI
            .grouped(UserAccountModel.guard())
            .post("add-products", use: controller.addProducts)
        
        let productAPI = routes
            .grouped("api")
            .grouped("products")
        
        productAPI
            .get("all", use: controller.products)

    }
}

import Vapor

struct ShoppingListRouter: RouteCollection {
    let controller = ShoppingListController()
    
    func boot(routes: any RoutesBuilder) throws {
        let listAPI = routes
            .grouped("api")
            .grouped("shopping-list")
        
        
    }
}

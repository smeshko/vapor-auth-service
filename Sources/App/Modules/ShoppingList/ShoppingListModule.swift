import Common
import Vapor

struct ShoppingListModule: ModuleInterface {
    let router = ShoppingListRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(ProductModelMigrations.v1())
        app.migrations.add(ShoppingListMigrations.v1())
        app.migrations.add(ShoppingListItemMigrations.v1())
        
        try router.boot(routes: app.routes)
    }
}

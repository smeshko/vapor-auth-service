import Common
import Vapor

struct BusinessModule: ModuleInterface {
    let router = BusinessRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(BusinessMigrations.v1())
        app.migrations.add(OpeningHoursMigrations.v1())
        
        try router.boot(routes: app.routes)
    }
}

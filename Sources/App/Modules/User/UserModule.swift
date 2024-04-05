import Common
import Vapor

struct UserModule: ModuleInterface {

    let router = UserRouter()

    func boot(_ app: Application) throws {
        app.migrations.add(UserMigrations.v1())
        app.migrations.add(LocationMigrations.v1())

        if app.environment == .development {
            app.migrations.add(UserMigrations.seed())
        }
        
        try router.boot(routes: app.routes)
    }
}

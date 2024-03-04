import Vapor

struct UserModule: ModuleInterface {

    let router = UserRouter()

    func boot(_ app: Application) throws {
        app.migrations.add(UserMigrations.v1())
        if app.environment == .development {
            app.migrations.add(UserMigrations.seed())
        }
        
        app.middleware.use(UserPayloadAuthenticator())
        
        try router.boot(routes: app.routes)
    }
}

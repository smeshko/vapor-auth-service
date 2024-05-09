import Common
import Vapor

struct MediaModule: ModuleInterface {
    let router = MediaRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(MediaMigrations.v1())
        app.migrations.add(MediaMigrations.seed())
        
        try router.boot(routes: app.routes)
    }
}

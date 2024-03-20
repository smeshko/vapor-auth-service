import Common
import Vapor

struct PostModule: ModuleInterface {
    let router = PostRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(PostMigrations.v1())
        
        try router.boot(routes: app.routes)
    }
}

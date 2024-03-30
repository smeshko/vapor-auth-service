import Common
import Vapor

struct CommentModule: ModuleInterface {
    let router = CommentRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(CommentMigrations.v1())
        
        try router.boot(routes: app.routes)
    }
}

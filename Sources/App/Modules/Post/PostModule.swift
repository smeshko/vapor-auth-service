import Common
import Vapor

struct PostModule: ModuleInterface {
    let postRouter = PostRouter()
    let mediaRouter = MediaRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(PostMigrations.v1())
        
        try postRouter.boot(routes: app.routes)
        try mediaRouter.boot(routes: app.routes)
    }
}

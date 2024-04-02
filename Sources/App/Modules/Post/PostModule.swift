import Common
import Vapor

struct PostModule: ModuleInterface {
    let postRouter = PostRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(PostMigrations.v1())
        
        try postRouter.boot(routes: app.routes)
    }
}

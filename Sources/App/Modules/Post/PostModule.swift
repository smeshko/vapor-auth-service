import Common
import Vapor

struct PostModule: ModuleInterface {
    let postRouter = PostRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(PostMigrations.v1())
        app.migrations.add(LikesMigrations.v1())
        
        if app.environment == .development {
            app.migrations.add(PostMigrations.seed())
        }
        
        try postRouter.boot(routes: app.routes)
    }
}

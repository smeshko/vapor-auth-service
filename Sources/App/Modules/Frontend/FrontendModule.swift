import Common
import Vapor

struct FrontendModule: ModuleInterface {

    let router = FrontendRouter()

    func boot(_ app: Application) throws {        
        try router.boot(routes: app.routes)
    }
}

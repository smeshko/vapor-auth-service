import Common
import Vapor

struct BusinessModule: ModuleInterface {
    let router = BusinessRouter()
    
    func boot(_ app: Application) throws {
        
        try router.boot(routes: app.routes)
    }
}

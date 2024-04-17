import Common
import Vapor

struct ExternalServicesModule: ModuleInterface {
    let router = ExternalServicesRouter()

    func boot(_ app: Application) throws {
        try router.boot(routes: app.routes)
    }
}

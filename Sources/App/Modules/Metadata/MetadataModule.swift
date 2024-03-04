import Vapor

struct MetadataModule: ModuleInterface {
    
    let router = MetadataRouter()
    
    func boot(_ app: Application) throws {
        app.migrations.add(MetadataMigrations.v1())
        
        try router.boot(routes: app.routes)
    }
}

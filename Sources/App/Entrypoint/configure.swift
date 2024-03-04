import Vapor

extension Environment {
    static var staging: Environment {
        .custom(name: "staging")
    }
}

public func configure(_ app: Application) throws {

    app.setupMiddleware()
    try app.setupDB()
    try app.setupJWT()
    try app.setupModules()
    app.setupServices()
    
    app.logger.info("Environment: \(app.environment.name)")
    
    if app.environment == .development {
        try app.autoMigrate().wait()
    }
}

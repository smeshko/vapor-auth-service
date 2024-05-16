import Vapor

extension Environment {
    static var staging: Environment {
        .custom(name: "staging")
    }
}

public func configure(_ app: Application) throws {

    app.setupEnvironment()
    app.setupMiddleware()
    try app.setupDB()
    try app.setupJWT()
    try app.setupModules()
    app.setupServices()
    try app.setupAPNS()

    app.logger.info("Environment: \(app.environment.name)")
    
//    try app.autoRevert().wait()
    try app.autoMigrate().wait()
}

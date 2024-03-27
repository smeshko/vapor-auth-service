import Common
import FluentPostgresDriver
import FluentSQLiteDriver
import JWT
import Vapor

private extension String {
    var bytes: [UInt8] { .init(self.utf8) }
}

private extension JWKIdentifier {
    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

extension Application {
    
    func setupEnvironment() {
        guard environment != .testing else { return }
        environment = Environment(name: Environment.named)
    }

    func setupMiddleware() {
        middleware = .init()
        let file = FileMiddleware(publicDirectory: directory.publicDirectory)
        middleware.use(file)
        routes.defaultMaxBodySize = "10mb"
        middleware.use(ErrorMiddleware.custom(environment: environment))
        middleware.use(FileMiddleware(publicDirectory: directory.publicDirectory))
    }
    
    func setupModules() throws {
        var modules: [ModuleInterface] = [
            UserModule(),
            AuthModule(),
            FrontendModule(),
            PostModule(),
            MediaModule()
        ]
        
        if environment != .testing {
            modules.append(MetricsModule())
        }
        
        for module in modules {
            try module.boot(self)
        }
        
        for module in modules {
            try module.setUp(self)
        }
    }
    
    func setupDB() throws {
        if environment == .testing {
            databases.use(.sqlite(.memory), as: .sqlite)
            return
        }
        let postgresConfig = SQLPostgresConfiguration(
//            hostname: Environment.databaseHost,
            hostname: "localhost",
            port: Environment.databasePort,
            username: Environment.databaseUser,
            password: Environment.databasePassword,
            database: Environment.databaseName,
            tls: .disable
        )
        databases.use(.postgres(configuration: postgresConfig), as: .psql)
    }
    
    func setupJWT() throws {
        if environment != .testing {
            jwt.signers.use(.hs256(key: Environment.jwtKey))
        }
    }
    
    func setupServices() {
        randomGenerators.use(.random)
        repositories.use(.database)
        email.use(.brevo)
        fileStorage.use(.s3)
    }
}

import Vapor

// MARK: - Database
extension Environment {
    static var databaseName: String {
        if let key = Environment.get("DATABASE_NAME") {
            return key
        } else {
            fatalError("DATABASE_NAME is empty")
        }
    }
    
    static var databaseHost: String {
        if let key = Environment.get("DATABASE_HOST") {
            return key
        } else {
            fatalError("DATABASE_HOST is empty")
        }
    }
    
    static var databaseUser: String {
        if let key = Environment.get("DATABASE_USERNAME") {
            return key
        } else {
            fatalError("DATABASE_USERNAME is empty")
        }
    }
    
    static var databasePassword: String {
        if let key = Environment.get("DATABASE_PASSWORD") {
            return key
        } else {
            fatalError("DATABASE_PASSWORD is empty")
        }
    }
    
    static var databasePort: Int {
        if let key = Environment.get("DATABASE_PORT"),
           let port = Int(key) {
            return port
        } else {
            fatalError("DATABASE_PORT is empty")
        }
    }
}

// MARK: - API
extension Environment {
    static var mailProviderKey: String {
        if let key = Environment.get("BREVO_API_KEY") {
            return key
        } else {
            fatalError("BREVO_API_KEY is empty")
        }
    }
    
    static var mailProviderUrl: String {
        if let key = Environment.get("BREVO_URL") {
            return key
        } else {
            fatalError("BREVO_URL is empty")
        }
    }
    
    static var jwtKey: String {
        if let key = Environment.get("JWT_KEY") {
            return key
        } else {
            fatalError("JWT_KEY is empty")
        }
    }
}

// MARK: - Setup
extension Environment {
    static var named: String {
        Environment.get("ENV") ?? "prod"
    }
    
    static var baseURL: String {
        if let baseURL = Environment.get("BASE_URL") {
            return baseURL
        } else {
            fatalError("BASE_URL is empty")
        }
    }
}

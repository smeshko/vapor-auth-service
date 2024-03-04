import Vapor
import Fluent
import Entities

public protocol RequestService {
    func `for`(_ req: Request) -> Self
}

public protocol Repository: RequestService {
    associatedtype Model: DatabaseModelInterface
    
    func delete(id: UUID) async throws
    func count() async throws -> Int
}

public extension Repository where Self: DatabaseRepository {
    func delete(id: UUID) async throws {
        try await Model.find(id, on: database)?
            .delete(on: database)
    }
    
    func count() async throws -> Int {
        try await Model.query(on: database).count()
    }
}

public protocol DatabaseRepository: Repository {
    var database: Database { get }
    init(database: Database)
}

public extension DatabaseRepository {
    func `for`(_ req: Request) -> Self {
        return Self.init(database: req.db)
    }
}

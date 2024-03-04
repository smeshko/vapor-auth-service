@testable import App
import Vapor
import Entities

class TestEmailTokenRepository: EmailTokenRepository, TestRepository {
    typealias Model = EmailTokenModel
    var tokens: [EmailTokenModel]
    
    init(tokens: [EmailTokenModel] = []) {
        self.tokens = tokens
    }
    
    func find(token: String) async throws -> EmailTokenModel? {
        tokens.first(where: { $0.value == token })
    }
    
    func find(forUserID id: UUID) async throws -> EmailTokenModel? {
        tokens.first(where: { $0.$user.id == id })
    }
    
    func delete(forUserID id: UUID) async throws {
        tokens.removeAll(where: { $0.$user.id == id })
    }
    
    func create(_ model: EmailTokenModel) async throws {
        model.id = UUID()
        tokens.append(model)
    }
    
    func all() async throws -> [EmailTokenModel] {
        tokens
    }
    
    func find(id: UUID) async throws -> EmailTokenModel? {
        tokens.first(where: { $0.id == id })
    }
    
    func delete(id: UUID) async throws {
        tokens.removeAll(where: { $0.id == id })
    }
    
    func count() async throws -> Int {
        tokens.count
    }
}

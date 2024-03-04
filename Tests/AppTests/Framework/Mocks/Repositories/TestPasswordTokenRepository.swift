@testable import App
import Vapor
import Entities

final class TestPasswordTokenRepository: PasswordTokenRepository, TestRepository {
    var tokens: [PasswordTokenModel]
    typealias Model = PasswordTokenModel

    init(tokens: [PasswordTokenModel] = []) {
        self.tokens = tokens
    }
    
    func find(token: String) async throws -> PasswordTokenModel? {
        tokens.first(where: { $0.value == token })
    }
    
    func find(forUserID id: UUID) async throws -> PasswordTokenModel? {
        tokens.first(where: { $0.$user.id == id })
    }
    
    func delete(forUserID id: UUID) async throws {
        tokens.removeAll(where: { $0.$user.id == id })
    }
    
    func create(_ model: PasswordTokenModel) async throws {
        model.id = UUID()
        tokens.append(model)
    }
    
    func all() async throws -> [PasswordTokenModel] {
        tokens
    }
    
    func find(id: UUID) async throws -> PasswordTokenModel? {
        tokens.first(where: { $0.id == id })
    }
    
    func delete(id: UUID) async throws {
        tokens.removeAll(where: { $0.id == id })
    }
    
    func count() async throws -> Int {
        tokens.count
    }
}

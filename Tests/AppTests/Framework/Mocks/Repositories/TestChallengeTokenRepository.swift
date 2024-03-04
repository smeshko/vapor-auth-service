@testable import App
import Vapor
import Entities

class TestChallengeTokenRepository: ChallengeTokenRepository, TestRepository {
    typealias Model = ChallengeTokenModel
    var tokens: [ChallengeTokenModel]
    
    init(tokens: [ChallengeTokenModel] = []) {
        self.tokens = tokens
    }
    
    func find(value: String) async throws -> ChallengeTokenModel? {
        tokens.first(where: { $0.value == value })
    }
    
    func create(_ model: ChallengeTokenModel) async throws {
        model.id = UUID()
        tokens.append(model)
    }
    
    func delete(id: UUID) async throws {
        tokens.removeAll(where: { $0.id == id })
    }
    
    func count() async throws -> Int {
        tokens.count
    }
}

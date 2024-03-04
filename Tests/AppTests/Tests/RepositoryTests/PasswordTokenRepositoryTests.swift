@testable import App
import Fluent
import XCTVapor

final class PasswordTokenRepositoryTests: XCTestCase {
    var app: Application!
    var repository: (any PasswordTokenRepository)!
    var user: UserAccountModel!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabasePasswordTokenRepository(database: app.db)
        try app.autoMigrate().wait()
        
        user = .init(email: "test@test.com", password: "123", fullName: "Test User")
        try user.create(on: app.db).wait()
    }
    
    override func tearDownWithError() throws {
        try app.migrator.revertAllBatches().wait()
        app.shutdown()
    }
    
    func testFindByUserID() async throws {
        let userID = try user.requireID()
        let token = PasswordTokenModel(userID: userID, value: "123")
        try await token.create(on: app.db)
        
        try await XCTAssertNotNilAsync(await repository.find(forUserID: userID))
    }
    
    func testFindByToken() async throws {
        let token = PasswordTokenModel(userID: try user.requireID(), value: "token123")
        try await token.create(on: app.db)
        try await XCTAssertNotNilAsync(await repository.find(token: "token123"))
    }
    
    func testCount() async throws {
        let token = PasswordTokenModel(userID: try user.requireID(), value: "token123")
        let token2 = PasswordTokenModel(userID: try user.requireID(), value: "token1234")
        try await [token, token2].create(on: app.db)
        let count = try await repository.count()
        XCTAssertEqual(count, 2)
    }
    
    func testCreate() async throws {
        let token = PasswordTokenModel(userID: try user.requireID(), value: "token123")
        try await repository.create(token)
        try XCTAssertNotNil(PasswordTokenModel.find(try token.requireID(), on: app.db).wait())
    }
    
    func testDelete() async throws {
        let token = PasswordTokenModel(userID: try user.requireID(), value: "token123")
        try await token.create(on: app.db)
        try await repository.delete(id: token.requireID())
        let count = try await PasswordTokenModel.query(on: app.db).count()
        XCTAssertEqual(count, 0)
    }
}

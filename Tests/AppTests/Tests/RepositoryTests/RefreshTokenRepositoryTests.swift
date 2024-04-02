@testable import App
import Fluent
import XCTVapor

final class RefreshTokenRepositoryTests: XCTestCase {
    var app: Application!
    var repository: (any RefreshTokenRepository)!
    var user: UserAccountModel!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseRefreshTokenRepository(database: app.db)
        try app.autoMigrate().wait()
        user = UserAccountModel(
            email: "test@test.com",
            password: "123"
        )
    }
    
    override func tearDownWithError() throws {
        try app.migrator.revertAllBatches().wait()
        app.shutdown()
    }
    
    func testCreatingToken() async throws {
        try await user.create(on: app.db)
        let token = try RefreshTokenModel(value: "123", userID: user.requireID())
        try await repository.create(token)
        
        XCTAssertNotNil(token.id)
        
        let tokenRetrieved = try await RefreshTokenModel.find(token.id, on: app.db)
        XCTAssertNotNil(tokenRetrieved)
        XCTAssertEqual(tokenRetrieved!.$user.id, try user.requireID())
    }
    
    func testFindingTokenById() async throws {
        try await user.create(on: app.db)
        let token = try RefreshTokenModel(value: "123", userID: user.requireID())
        try await token.create(on: app.db)
        let tokenId = try token.requireID()
        let tokenFound = try await repository.find(id: tokenId)
        XCTAssertNotNil(tokenFound)
    }
    
    func testFindingTokenByTokenString() async throws {
        try await user.create(on: app.db)
        let token = try RefreshTokenModel(value: "123", userID: user.requireID())
        try await token.create(on: app.db)
        let tokenFound = try await repository.find(token: "123")
        XCTAssertNotNil(tokenFound)
    }
    
    func testDeletingToken() async throws {
        try await user.create(on: app.db)
        let token = try RefreshTokenModel(value: "123", userID: user.requireID())
        try await token.create(on: app.db)
        let tokenCount = try await RefreshTokenModel.query(on: app.db).count()
        XCTAssertEqual(tokenCount, 1)
        try await repository.delete(id: token.requireID())
        let newTokenCount = try await RefreshTokenModel.query(on: app.db).count()
        XCTAssertEqual(newTokenCount, 0)
    }
    
    func testGetCount() async throws {
        try await user.create(on: app.db)
        let token = try RefreshTokenModel(value: "123", userID: user.requireID())
        try await token.create(on: app.db)
        let tokenCount = try await repository.count()
        XCTAssertEqual(tokenCount, 1)
    }
}

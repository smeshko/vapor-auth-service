@testable import App
import Fluent
import XCTVapor

final class EmailTokenRepositoryTests: XCTestCase {
    var app: Application!
    var repository: (any EmailTokenRepository)!
    var user: UserAccountModel!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseEmailTokenRepository(database: app.db)
        try app.autoMigrate().wait()
        
        user = .init(email: "test@test.com", password: "123")
    }
    
    override func tearDownWithError() throws {
        try app.autoRevert().wait()
        app.shutdown()
    }
    
    func testCreatingEmailToken() async throws {
        try await user.create(on: app.db)
        let emailToken = EmailTokenModel(userID: try user.requireID(), value: "emailToken")
        try await repository.create(emailToken)
        
        let count = try await EmailTokenModel.query(on: app.db).count()
        XCTAssertEqual(count, 1)
    }
    
    func testFindingEmailTokenByToken() async throws {
        try await user.create(on: app.db)
        let emailToken = EmailTokenModel(userID: try user.requireID(), value: "123")
        try await emailToken.create(on: app.db)
        let found = try await repository.find(token: "123")
        XCTAssertNotNil(found)
    }
    
    func testDeleteEmailToken() async throws {
        try await user.create(on: app.db)
        let emailToken = EmailTokenModel(userID: try user.requireID(), value: "123")
        try await emailToken.create(on: app.db)
        try await repository.delete(id: emailToken.requireID())
        let count = try await EmailTokenModel.query(on: app.db).count()
        XCTAssertEqual(count, 0)
    }
}
    


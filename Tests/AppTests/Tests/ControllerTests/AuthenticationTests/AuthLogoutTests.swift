@testable import App
import Entities
import XCTVapor

final class AuthLogoutTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    let logoutPath = "api/auth/logout"
    var user: UserAccountModel!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testLogoutHappyPath() async throws {
        try await app.repositories.users.create(user)
        
        try await app.test(.POST, logoutPath, user: user) { res in
            XCTAssertEqual(res.status, .ok)
            
            let count = try await app.repositories.refreshTokens.count()
            XCTAssertEqual(count, 0)
        }
    }
    
    func testLogoutNotLoggedIn() async throws {
        try app.test(.POST, logoutPath) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
}

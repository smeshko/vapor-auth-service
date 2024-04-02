@testable import App
import Entities
import Fluent
import XCTVapor
import Crypto

final class AuthenticationTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testGettingCurrentUser() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123", isAdmin: true)
        try await app.repositories.users.create(user)
        
        try await app.test(.GET, "api/user/me", user: user, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContent(User.Detail.Response.self, res) { userContent in
                XCTAssertEqual(userContent.email, "test@test.com")
                XCTAssertEqual(userContent.isAdmin, true)
                XCTAssertEqual(userContent.id, user.id)
            }
        })
    }
}

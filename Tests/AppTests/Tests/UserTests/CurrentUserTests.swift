@testable import App
import Entities
import Fluent
import XCTVapor

final class CurrentUserTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let mePath = "api/user/me"
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testMeHappyPath() async throws {
        try await app.repositories.users.create(user)
        try await app.test(.GET, mePath, user: user) { response in
            XCTAssertContent(User.Detail.Response.self, response) { userResponse in
                XCTAssertEqual(userResponse.email, "test@test.com")
                XCTAssertEqual(userResponse.firstName, "John")
                XCTAssertEqual(userResponse.lastName, "Doe")
                XCTAssertEqual(userResponse.isEmailVerified, true)
            }
        }
    }
}

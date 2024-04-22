@testable import App
import Entities
import Fluent
import XCTVapor
import Crypto

final class UserGetCurrentUserTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    let path = "api/user/me"
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testCurrentUserHappyPath() async throws {
        let user = try UserAccountModel.mock(app: app)
        try await app.repositories.users.create(user)
        
        try await app.test(.GET, path, user: user) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContent(User.Detail.Response.self, res) { userContent in
                XCTAssertEqual(userContent.email, "test@test.com")
                XCTAssertEqual(userContent.isAdmin, false)
                XCTAssertEqual(userContent.firstName, user.firstName)
                XCTAssertEqual(userContent.lastName, user.lastName)
                XCTAssertNil(userContent.location)
                XCTAssertEqual(userContent.id, user.id)
            }
        }
    }
    
    func testCurrentUserWithLocation() async throws {
        let user = try UserAccountModel.mock(app: app)
        try await app.repositories.users.create(user)
        let location = LocationModel.mock(userId: user.id!)
        try await app.repositories.users.add(location, to: user)
        
        try await app.test(.GET, path, user: user) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContent(User.Detail.Response.self, res) { userContent in
                XCTAssertEqual(userContent.email, "test@test.com")
                XCTAssertEqual(userContent.isAdmin, false)
                XCTAssertEqual(userContent.firstName, user.firstName)
                XCTAssertEqual(userContent.lastName, user.lastName)
                XCTAssertEqual(userContent.id, user.id)

                XCTAssertNotNil(userContent.location)
                XCTAssertEqual(userContent.location?.address, user.location?.address)
            }
        }
    }

    func testCurrentUserNotLoggedIn() async throws {
        try app.test(.GET, path) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
}

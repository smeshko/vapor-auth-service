@testable import App
import Entities
import Fluent
import XCTVapor

final class DeleteUserTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let deletePath = "api/user/delete"
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel(
            email: "test@test.com",
            password: app.password.hash("password"),
            isEmailVerified: true
        )

    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testDeleteHappyPath() async throws {
        try await app.repositories.users.create(user)
        try await app.test(.DELETE, deletePath, user: user) { response in
            let users = try await app.repositories.users.all()
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(users.count, 0)
        }
    }
    
    func testListUnauthenticatedRequestShouldFail() async throws {
        try app.test(.DELETE, deletePath) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
}

@testable import App
import Entities
import Fluent
import XCTVapor
import Crypto

extension User.Update.Request: Content {}

final class PatchTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let patchPath = "api/user/update"

    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel(
            email: "test@test.com",
            password: app.password.hash("password"),
            fullName: "Test User",
            isEmailVerified: true
        )
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testPatchHappyPath() async throws {
        try await app.repositories.users.create(user)
        
        let patchContent = User.Update.Request(
            email: "new_mail@test.com",
            fullName: "New name"
        )
        
        try await app.test(.PATCH, patchPath, user: user, content: patchContent, afterResponse: { res in
            XCTAssertContent(User.Update.Response.self, res) { patchContent in
                XCTAssertEqual(patchContent.email, "new_mail@test.com")
                XCTAssertEqual(patchContent.fullName, "New name")
            }
        })
    }
}

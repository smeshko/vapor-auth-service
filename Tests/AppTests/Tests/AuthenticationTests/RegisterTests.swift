@testable import App
import Entities
import Fluent
import XCTVapor
import Crypto

extension Auth.SignUp.Request: Content {}

final class RegisterTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    let registerPath = "api/auth/sign-up"
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testRegisterHappyPath() async throws {
        app.randomGenerators.use(.rigged(value: "token"))
        
        let data = Auth.SignUp.Request(
            email: "test@test.com",
            password: "password123",
            firstName: "Test",
            lastName: "User"
        )
        
        try app.test(.POST, registerPath, beforeRequest: { req in
            try req.content.encode(data)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContent(Auth.SignUp.Response.self, res) { signup in
                XCTAssertEqual(signup.user.email, "test@test.com")
                XCTAssertEqual(signup.user.firstName, "Test")
                XCTAssertEqual(signup.user.lastName, "User")
                XCTAssert(!signup.token.refreshToken.isEmpty)
                XCTAssert(!signup.token.accessToken.isEmpty)
            }
        })
    }
    
    func testRegisterFailsWithExistingEmail() async throws {
        try await app.autoMigrate()
        defer { try! app.autoRevert().wait() }

        app.repositories.use(.database)
        
        let user = UserAccountModel(
            email: "test@test.com",
            password: "123"
        )

        try await user.create(on: app.db)

        let registerRequest = Auth.SignUp.Request(
            email: "test@test.com",
            password: "password123"
        )
        
        try await app.test(.POST, registerPath, beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.emailAlreadyExists)
            let users = try await UserAccountModel.query(on: app.db).all()
            XCTAssertEqual(users.count, 1)
        })
    }
}


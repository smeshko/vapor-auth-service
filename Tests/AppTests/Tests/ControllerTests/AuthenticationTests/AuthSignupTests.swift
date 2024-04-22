@testable import App
import Entities
import Fluent
import XCTVapor
import Crypto
import Common

extension Auth.SignUp.Request: Content {}

final class AuthSignupTests: XCTestCase {
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
            location: .mock(),
            firstName: "Test",
            lastName: "User"
        )
        
        try await app.test(.POST, registerPath, beforeRequest: { req in
            try req.content.encode(data)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            try await XCTAssertContentAsync(Auth.SignUp.Response.self, res) { signup in
                XCTAssertEqual(signup.user.email, "test@test.com")
                XCTAssertEqual(signup.user.firstName, "Test")
                XCTAssertEqual(signup.user.lastName, "User")
                XCTAssertEqual(signup.user.isAdmin, false)
                XCTAssertEqual(signup.user.isEmailVerified, false)
                XCTAssertEqual(signup.user.location, Location.mock())
                
                let model = try await app.repositories.users.find(id: signup.user.id)!
                XCTAssertTrue(try BCryptDigest().verify("password123", created: model.password!))
                
                let emailToken = try await app.repositories.emailTokens.find(token: SHA256.hash("token"))
                XCTAssertEqual(emailToken?.$user.id, signup.user.id)
                XCTAssertNotNil(emailToken)
                                
                XCTAssertFalse(signup.token.refreshToken.isEmpty)
                XCTAssertFalse(signup.token.accessToken.isEmpty)
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
            password: "password123",
            location: nil
        )
        
        try await app.test(.POST, registerPath, beforeRequest: { req in
            try req.content.encode(registerRequest)
        }, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.emailAlreadyExists)
            let users = try await UserAccountModel.query(on: app.db).all()
            XCTAssertEqual(users.count, 1)
        })
    }
    
    func testRegisterValidations() async throws {
        app.randomGenerators.use(.rigged(value: "token"))

        let data = Auth.SignUp.Request(
            email: "TEStest.com",
            password: "pass",
            location: .mock(),
            firstName: "Test",
            lastName: "User"
        )

        try app.test(.POST, registerPath, beforeRequest: { req in
            try req.content.encode(data)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertContent(ErrorResponse.self, res) { error in
                XCTAssertEqual(error.reason, "email is not a valid email address, password is less than minimum of 8 character(s)")
            }
        })
    }
    
    func testRegisterLowercaseEmail() async throws {
        app.randomGenerators.use(.rigged(value: "token"))

        let data = Auth.SignUp.Request(
            email: "TEST@test.com",
            password: "password123",
            location: .mock(),
            firstName: "Test",
            lastName: "User"
        )

        try app.test(.POST, registerPath, beforeRequest: { req in
            try req.content.encode(data)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContent(Auth.SignUp.Response.self, res) { signup in
                XCTAssertEqual(signup.user.email, "test@test.com")
            }
        })
    }
}


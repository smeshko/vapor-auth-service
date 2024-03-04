@testable import App
import Fluent
import XCTVapor
import Crypto
import Entities

extension Auth.PasswordReset.Request: Content {}
extension PasswordResetInput: Content {}

final class ResetPasswordTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    let path = "api/auth/reset-password"
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testResetPassword() async throws {
        app.randomGenerators.use(.rigged(value: "passwordtoken"))
        
        let user = UserAccountModel(email: "test@test.com", password: "123", fullName: "Test User")
        try await app.repositories.users.create(user)
        
        let resetPasswordRequest = Auth.PasswordReset.Request(email: "test@test.com")
        
        try await app.test(.POST, path, beforeRequest: { req in
            try req.content.encode(resetPasswordRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let count = try await app.repositories.passwordTokens.count()
            XCTAssertEqual(count, 1)
        })
    }
    
    func testResetPasswordSucceedsWithNonExistingEmail() async throws {
        let resetPasswordRequest = Auth.PasswordReset.Request(email: "none@test.com")
        
        try await app.test(.POST, path, content: resetPasswordRequest, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.userNotFound)
        })
    }

    func testRecoverAccount() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "oldpassword", fullName: "Test User")
        try await app.repositories.users.create(user)
        let hashedToken = SHA256.hash("passwordtoken")
        let tokenModel = try PasswordTokenModel(userID: user.requireID(), value: hashedToken)
        tokenModel.$user.value = user
        
        try await app.repositories.passwordTokens.create(tokenModel)
        
        let recoverRequest = PasswordResetInput(password: "newpassword", confirmPassword: "newpassword")
        
        try await app.test(.POST, "reset-password?token=\(hashedToken)", content: recoverRequest, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try await app.repositories.users.find(id: user.requireID())!
            try XCTAssertTrue(BCryptDigest().verify("newpassword", created: user.password))
            let count = try await app.repositories.passwordTokens.count()
            XCTAssertEqual(count, 0)
        })
    }

    func testRecoverAccountWithExpiredTokenFails() async throws {
        let hashedToken = SHA256.hash("passwordtoken")
        let token = PasswordTokenModel(userID: UUID(), value: hashedToken, expiresAt: Date().addingTimeInterval(-60))
        try await app.repositories.passwordTokens.create(token)
        
        try app.test(.GET, "reset-password?token=\(hashedToken)", afterResponse: { res in
            let html = try XCTUnwrap(String(data: Data(buffer: res.body), encoding: .utf8))
            XCTAssertTrue(html.contains("Token expired"))
        })
    }
    
    func testRecoverAccountWithInvalidTokenFails() async throws {
        try app.test(.GET, "reset-password?token=blah", afterResponse: { res in
            let html = try XCTUnwrap(String(data: Data(buffer: res.body), encoding: .utf8))
            XCTAssertTrue(html.contains("Token not found"))
        })
    }
}

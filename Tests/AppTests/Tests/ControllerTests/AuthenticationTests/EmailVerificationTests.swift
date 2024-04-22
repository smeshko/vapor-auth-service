
@testable import App
import Fluent
import XCTVapor
import Crypto

final class EmailVerificationTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    let verifyURL = "verify-email"
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testVerifyingEmailHappyPath() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        try await app.repositories.users.create(user)
        let expectedHash = SHA256.hash("token123")
        
        let emailToken = EmailTokenModel(userID: try user.requireID(), value: expectedHash)
        emailToken.$user.value = user
        try await app.repositories.emailTokens.create(emailToken)
        
        try await app.test(.GET, verifyURL, beforeRequest: { req in
            try req.query.encode(["token": expectedHash])
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let user = try await XCTUnwrapAsync(await app.repositories.users.find(id: user.id!))
            XCTAssertEqual(user.isEmailVerified, true)
            let token = try await app.repositories.emailTokens.find(forUserID: user.requireID())
            XCTAssertNil(token)
        })
    }
    
    func testVerifyingEmailWithInvalidTokenFails() async throws {
        try app.test(.GET, verifyURL, beforeRequest: { req in
            try req.query.encode(["token": "blabla"])
        }, afterResponse: { res in
            let html = try XCTUnwrap(String(data: Data(buffer: res.body), encoding: .utf8))
            XCTAssertTrue(html.contains("Token not found"))
        })
    }
    
    func testVerifyingEmailWithExpiredTokenFails() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        try await app.repositories.users.create(user)
        let expectedHash = SHA256.hash("token123")
        let emailToken = EmailTokenModel(userID: try user.requireID(), value: expectedHash, expiresAt: Date().addingTimeInterval(-15.minutes - 1) )
        emailToken.$user.value = user

        try await app.repositories.emailTokens.create(emailToken)
        
        try app.test(.GET, verifyURL, beforeRequest: { req in
            try req.query.encode(["token": expectedHash])
        }, afterResponse: { res in
            let html = try XCTUnwrap(String(data: Data(buffer: res.body), encoding: .utf8))
            XCTAssertTrue(html.contains("Token expired"))
        })
    }
}

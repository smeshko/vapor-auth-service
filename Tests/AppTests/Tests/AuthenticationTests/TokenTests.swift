@testable import App
import Entities
import Fluent
import XCTVapor
import Crypto

extension Auth.TokenRefresh.Request: Content {}

final class TokenTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    let accessTokenPath = "api/auth/refresh"
    var user: UserAccountModel!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
        
        user = UserAccountModel(email: "test@test.com", password: "123", fullName: "Test User")
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testRefreshAccessToken() async throws {
        app.randomGenerators.use(.rigged(value: "secondrefreshtoken"))
        
        try await app.repositories.users.create(user)
        
        let refreshToken = try RefreshTokenModel(value: SHA256.hash("firstrefreshtoken"), userID: user.requireID())
        
        try await app.repositories.refreshTokens.create(refreshToken)
        let tokenID = try refreshToken.requireID()
        
        let accessTokenRequest = Auth.TokenRefresh.Request(refreshToken: "firstrefreshtoken")
        
        try await app.test(.POST, accessTokenPath, content: accessTokenRequest) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertContent(Auth.TokenRefresh.Response.self, res) { response in
                XCTAssert(!response.accessToken.isEmpty)
                XCTAssertEqual(response.refreshToken, "secondrefreshtoken")
            }
            let deletedToken = try await app.repositories.refreshTokens.find(id: tokenID)
            XCTAssertNil(deletedToken)
            let newToken = try await app.repositories.refreshTokens.find(token: SHA256.hash("secondrefreshtoken"))
            XCTAssertNotNil(newToken)
        }
    }
    
    func testRefreshAccessTokenFailsWithExpiredRefreshToken() async throws {
        try await app.repositories.users.create(user)
        let token = try RefreshTokenModel(value: SHA256.hash("123"), userID: user.requireID(), expiresAt: Date().addingTimeInterval(-60))
        
        try await app.repositories.refreshTokens.create(token)
        
        let accessTokenRequest = Auth.TokenRefresh.Request(refreshToken: "123")

        try await app.test(.POST, accessTokenPath, content: accessTokenRequest, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.refreshTokenHasExpired)
        })
    }
}

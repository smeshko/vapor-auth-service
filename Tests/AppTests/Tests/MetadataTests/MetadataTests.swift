@testable import App
import Entities
import Fluent
import XCTVapor
import Crypto

final class MetadataTests: XCTestCase {
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
    
    func testGettingMetadata() async throws {
        let token = ChallengeTokenModel(value: "data")
        try await app.repositories.challengeTokens.create(token)
        
        let request = Metadata.Request(
            attestation: .init(
                attestation: Data(repeating: "a", count: 4),
                challenge: "data",
                keyID: Data(repeating: "k", count: 4),
                teamID: "team",
                bundleID: "bundle"
            )
        )
        
        try await app.test(.POST, "api/metadata/", content: request, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            try await XCTAssertContentAsync(Metadata.Response.self, res) { content in
                XCTAssertFalse(content.key.isEmpty)
                let tokensCount = try await app.repositories.challengeTokens.count()
                XCTAssertEqual(tokensCount, 0)
            }
        })
    }
    
    func testChallengeShouldCreateToken() async throws {
        app.randomGenerators.use(.rigged(value: "data"))
        
        try await app.test(.GET, "api/metadata/challenge") { res in
            let tokensCount = try await app.repositories.challengeTokens.count()
            XCTAssertEqual(tokensCount, 1)
            XCTAssertContent(Attestation.Challenge.Response.self, res) { content in
                XCTAssertEqual(content.value, "data")
            }
        }
    }
}

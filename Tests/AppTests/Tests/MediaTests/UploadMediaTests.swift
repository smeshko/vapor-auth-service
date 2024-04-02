@testable import App
import Common
import Entities
import Fluent
import XCTVapor

extension Media.Upload.Request: Content {}

final class UploadMediaTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let path = "api/media/upload"
    var request: Media.Upload.Request!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
        
        request = .init(
            data: Data(),
            ext: "jpg",
            type: .photo
        )
    }
    
    func testHappyPath() async throws {
        try await app.repositories.users.create(user)
        
        try await app.test(.POST, path, user: user, content: request) { response in
            try await XCTAssertContentAsync(Media.Upload.Response.self, response) { response in
                XCTAssertEqual(response.type, .photo)
                let count = try await app.repositories.media.count()
                XCTAssertEqual(count, 1)
            }
        }
    }
    
    func testUploadNotLoggedIn() async throws {
        try await app.test(.POST, path, content: request) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
}

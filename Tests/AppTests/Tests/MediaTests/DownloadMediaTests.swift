@testable import App
import Common
import Entities
import Fluent
import XCTVapor

extension Media.Download.Request: Content {}

final class DownloadMediaTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    var media: MediaModel!
    let path = "api/media/download"
    let uuid = UUIDGenerator.incrementing
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        media = .init(id: uuid(), type: "", ext: "", key: "")
    }
    
    func testHappyPath() async throws {
        try await app.repositories.media.create(media)
        
        try app.test(.GET, "\(path)/\(media.id!)") { response in
            XCTAssertContent(Media.Download.Response.self, response) { response in
                XCTAssertNotNil(response.data)
            }
        }
    }
    
    func testDownloadNonExistingMedia() async throws {
        try app.test(.GET, "\(path)/\(media.id!)") { response in
            XCTAssertEqual(response.status, .notFound)
        }
    }
}

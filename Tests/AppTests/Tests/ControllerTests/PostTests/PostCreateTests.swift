@testable import App
import Common
import Entities
import Fluent
import XCTVapor

extension Post.Create.Request: Content {}

final class PostCreateTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var post: Post.Create.Request!
    var testWorld: TestWorld!
    let path = "api/posts/create"
    let uuid = UUIDGenerator.incrementing
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
        
        post = .init(
            title: "This is a title",
            text: "This is a post",
            category: .restaurant,
            tags: [],
            imageIDs: [],
            videoIDs: []
        )
    }
    
    override func tearDown() {
        super.tearDown()
        app.shutdown()
    }
    
    func testCreateHappyPath() async throws {
        try await app.repositories.users.create(user)
        
        try await app.test(.POST, path, user: user, content: post) { response in
            try await XCTAssertContentAsync(Post.Create.Response.self, response) { postResponse in
                XCTAssertEqual(postResponse.text, "This is a post")
                let count = try await app.repositories.posts.count()
                XCTAssertEqual(count, 1)
            }
        }
    }
    
    func testCreateWithMedia() async throws {
        try await app.repositories.users.create(user)
        let id1 = uuid()
        let id2 = uuid()
        let image = MediaModel(id: id1, type: "photo", ext: "jpg", key: "\(id1).jpg")
        let video = MediaModel(id: id2, type: "video", ext: "mp4", key: "\(id2).mp4")
        
        try await app.repositories.media.create(image)
        try await app.repositories.media.create(video)
        
        post = .init(
            title: "This is a title",
            text: "This is a post",
            category: .restaurant,
            tags: [],
            imageIDs: [],
            videoIDs: []
        )
        
        try await app.test(.POST, path, user: user, content: post) { response in
            try await XCTAssertContentAsync(Post.Create.Response.self, response) { postResponse in
                XCTAssertEqual(postResponse.text, "This is a post")
                XCTAssertEqual(postResponse.imageIDs.first!, id1)
                XCTAssertEqual(postResponse.videoIDs.first!, id2)
                XCTAssertEqual(postResponse.videoIDs.count, 1)
                XCTAssertEqual(postResponse.imageIDs.count, 1)
                let count = try await app.repositories.posts.count()
                XCTAssertEqual(count, 1)
            }
        }
    }
    
    func testCreateNotLoggedIn() async throws {
        try await app.test(.POST, path, content: post) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
}

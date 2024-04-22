@testable import App
import Common
import Entities
import Fluent
import XCTVapor

final class PostUserPostsTests: XCTestCase {
    var app: Application!
    var post: PostModel!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let path = "api/posts/all"
    let uuid = UUIDGenerator.incrementing
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
    }
    
    override func tearDown() {
        super.tearDown()
        app.shutdown()
    }
    
    func testAllHappyPath() async throws {
        try await createPost()
        
        try app.test(.GET, "\(path)/\(user.id!)") { response in
            XCTAssertContent([Post.List.Response].self, response) { postResponse in
                XCTAssertEqual(postResponse.first!.text, post.text)
                XCTAssertEqual(postResponse.count, 1)
            }
        }
    }
    
    func testAllNonExistingUserId() async throws {
        try await createPost()
        
        try app.test(.GET, "\(path)/\(uuid())") { response in
            XCTAssertContent([Post.List.Response].self, response) { postResponse in
                XCTAssertEqual(postResponse.count, 0)
            }
        }
    }
    
    private func createPost() async throws {
        try await app.repositories.users.create(user)
        post = try .mock(user: user)
        try await app.repositories.posts.create(post)
    }
}

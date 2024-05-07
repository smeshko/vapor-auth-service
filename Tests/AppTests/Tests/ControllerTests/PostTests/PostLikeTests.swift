@testable import App
import Common
import Entities
import Fluent
import XCTVapor

final class PostLikeTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var post: PostModel!
    var testWorld: TestWorld!
    var path: String {
        "api/posts/like/\(post.id!)"
    }
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
    
    func testHappyPath() async throws {
        try await createPost()
        
        try await app.test(.POST, path, user: user) { response in
            XCTAssertContent(Post.Detail.Response.self, response) { postResponse in
                XCTAssertEqual(postResponse.text, "This is a post")
                XCTAssertEqual(postResponse.likes, 1)
            }
        }
    }
    
    func testPostNotFound() async throws {
        try await createPost()
        try await app.test(.POST, "api/posts/like/\(uuid())", user: user) { response in
            XCTAssertResponseError(response, ContentError.postNotFound)
        }
    }

    func testLikeNotLoggedIn() async throws {
        try await createPost()
        try app.test(.POST, path) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
    
    private func createPost() async throws {
        try await app.repositories.users.create(user)
        user.$location.value = .mock(userId: user.id!)
        post = try .mock(user: user)
        post.$user.value = user
        post.$comments.value = []
        try await app.repositories.posts.create(post)
    }
}

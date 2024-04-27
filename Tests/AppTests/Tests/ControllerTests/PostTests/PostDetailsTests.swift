@testable import App
import Common
import Entities
import Fluent
import XCTVapor

final class PostDetailsTests: XCTestCase {
    var app: Application!
    var post: PostModel!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let path = "api/posts"
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
    
    func testDetailsHappyPath() async throws {
        try await createPost()
        
        try app.test(.GET, "\(path)/\(post.id!)") { response in
            XCTAssertContent(Post.Detail.Response.self, response) { postResponse in
                XCTAssertEqual(postResponse.text, post.text)
            }
        }
    }
    
    func testDetailsPostNotFound() async throws {
        try app.test(.GET, "\(path)/\(uuid())") { response in
            XCTAssertResponseError(response, ContentError.contentNotFound)
        }
    }
    
    private func createPost() async throws {
        try await app.repositories.users.create(user)
        user.$location.value = .mock(userId: user.id!)
        post = try .mock(user: user)
        post.$user.value = user
        try await app.repositories.posts.create(post)
    }
}

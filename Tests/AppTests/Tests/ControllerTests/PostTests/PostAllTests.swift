@testable import App
import Common
import Entities
import Fluent
import XCTVapor

final class PostAllTests: XCTestCase {
    var app: Application!
    var post: PostModel!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let path = "api/posts/all"
    let uuid = UUIDGenerator.incrementing
    var imageId: UUID!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        imageId = uuid()
        user = try UserAccountModel.mock(app: app)
    }
    
    override func tearDown() {
        super.tearDown()
        app.shutdown()
    }
    
    func testAllHappyPath() async throws {
        try await createPost()
        
        try app.test(.GET, path) { response in
            try XCTAssertContent([Post.List.Response].self, response) { postResponse in
                let first = try XCTUnwrap(postResponse.first)
                XCTAssertEqual(first.text, post.text)
                XCTAssertEqual(first.thumbnail, imageId)
                XCTAssertEqual(first.createdAt.timeIntervalSince1970, post.createdAt!.timeIntervalSince1970, accuracy: 1)
                XCTAssertEqual(first.commentCount, post.comments.count)
                XCTAssertEqual(postResponse.count, 1)
            }
        }
    }
    
    private func createPost() async throws {
        try await app.repositories.users.create(user)
        post = try .mock(user: user, imageIDs: [imageId])
        try await app.repositories.posts.create(post)
        post.$user.value = user
        post.$comments.value = []
    }
}

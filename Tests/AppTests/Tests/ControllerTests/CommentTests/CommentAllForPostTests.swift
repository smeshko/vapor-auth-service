@testable import App
import Common
import Entities
import Fluent
import XCTVapor

final class CommentAllForPostTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var post: PostModel!
    var testWorld: TestWorld!
    let path = "api/comments/all"
    let uuid = UUIDGenerator.incrementing
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
    }
    
    func testHappyPath() async throws {
        try await createPost()
        
        try app.test(.GET, "\(path)/\(post.id!)") { response in
            XCTAssertContent([Comment.List.Response].self, response) { response in
                XCTAssertEqual(response.count, 1)
            }
        }
    }
    
    func testAllCommentsNonExistingPost() async throws {
        try app.test(.GET, "\(path)/\(uuid())") { response in
            XCTAssertResponseError(response, ContentError.postNotFound)
        }
    }

    private func createPost() async throws {
        try await app.repositories.users.create(user)
        post = try .mock(user: user)
        try await app.repositories.posts.create(post)
        
        let comment1 = CommentModel.mock(userId: user.id!, postId: post.id!)
        try await app.repositories.comments.create(comment1)
        
        comment1.$user.value = user
        comment1.$post.value = post
        post.$comments.value = [comment1]
    }
}

@testable import App
import Common
import Entities
import Fluent
import XCTVapor

extension Comment.Reply.Request: Content {}

final class CommentReplyTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var parent: CommentModel!
    var testWorld: TestWorld!
    let path = "api/comments/reply"
    var request: Comment.Reply.Request!
    let uuid = UUIDGenerator.incrementing
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
        
        request = .init(text: "This is a comment")
    }
    
    func testHappyPath() async throws {
        try await createPost()
        
        try await app.test(.POST, "\(path)/\(parent.id!)", user: user, content: request) { response in
            try await XCTAssertContentAsync(Comment.Reply.Response.self, response) { response in
                XCTAssertEqual(response.text, request.text)
                XCTAssertEqual(response.postID, parent.$post.id)
                XCTAssertEqual(response.parentId, parent.id)
                XCTAssertEqual(response.userID, user.id)
                let count = try await app.repositories.comments.count()
                XCTAssertEqual(count, 2)
            }
        }
    }
    
    func testReplyNotLoggedIn() async throws {
        try await createPost()

        try await app.test(.POST, "\(path)/\(parent.id!)", content: request) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }

    func testCommentNonExistingParent() async throws {
        try await createPost()

        try await app.test(.POST, "\(path)/\(uuid())", user: user, content: request) { response in
            XCTAssertResponseError(response, ContentError.parentCommentNotFound)
        }
    }

    private func createPost() async throws {
        try await app.repositories.users.create(user)

        let post = try PostModel.mock(
            id: uuid(),
            user: user
        )
        
        try await app.repositories.posts.create(post)
        
        parent = .mock(
            id: uuid(),
            userId: user.id!,
            postId: post.id!
        )
        
        try await app.repositories.comments.create(parent)
    }
}

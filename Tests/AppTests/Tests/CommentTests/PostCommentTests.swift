@testable import App
import Common
import Entities
import Fluent
import XCTVapor

extension Comment.Create.Request: Content {}

final class PostCommentTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var post: PostModel!
    var testWorld: TestWorld!
    let path = "api/comment/post"
    var request: Comment.Create.Request!
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
        
        try await app.test(.POST, "\(path)/\(post.id!)", user: user, content: request) { response in
            try await XCTAssertContentAsync(Comment.Create.Response.self, response) { response in
                XCTAssertEqual(response.text, request.text)
                let count = try await app.repositories.comments.count()
                XCTAssertEqual(count, 1)
            }
        }
    }
    
    func testUploadNotLoggedIn() async throws {
        try await app.test(.POST, path, content: request) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
    
    private func createPost() async throws {
        try await app.repositories.users.create(user)

        post = try PostModel(
            id: uuid(),
            user: user,
            imageIDs: [],
            videoIDs: [],
            text: "This is a post",
            tags: []
        )
        
        try await app.repositories.posts.create(post)
    }
}

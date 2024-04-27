@testable import App
import Fluent
import XCTVapor

final class CommentRepositoryTests: XCTestCase {
    var app: Application!
    var repository: (any CommentRepository)!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseCommentRepository(database: app.db)
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.migrator.revertAllBatches().wait()
        app.shutdown()
    }
    
    func testDefaultProvider() throws {
        let defaultProvider = app.repositories.comments
        XCTAssertTrue(type(of: defaultProvider) == DatabaseCommentRepository.self)
    }
    
    func testCreate() async throws {
        let model = try await createComment()
        let retrieved = try await repository.find(id: model.id!)
        XCTAssertNotNil(retrieved)
    }

    func testFindByID() async throws {
        let model = try await createComment()
        try await XCTAssertNotNilAsync(await repository.find(id: model.id!))
    }
        
    func testCount() async throws {
        let _ = try await createComment()
        let _ = try await createComment()

        let count = try await repository.count()
        XCTAssertEqual(count, 2)
    }
    
    func testDelete() async throws {
        let model = try await createComment()
        try await repository.delete(id: model.id!)
        
        let count = try await repository.count()
        XCTAssertEqual(count, 0)
    }
    
    func testUpdate() async throws {
        let model = try await createComment()
        model.text = "New text"
        try await repository.update(model)
        
        let found = try await XCTUnwrapAsync(await repository.find(id: model.id!))
        XCTAssertEqual(found.text, "New text")
    }
    
    func testAllForUser() async throws {
        let user1 = try UserAccountModel.mock(app: app, email: "test1@test.com")
        try await user1.create(on: app.db)
        
        let post1 = try PostModel.mock(user: user1)
        try await post1.create(on: app.db)
        
        let comment = CommentModel.mock(userId: user1.id!, postId: post1.id!)
        try await repository.create(comment)

        let user2 = try UserAccountModel.mock(app: app, email: "test@test.com")
        try await user2.create(on: app.db)
        
        let post2 = try PostModel.mock(user: user2)
        try await post2.create(on: app.db)
        
        let comment2 = CommentModel.mock(userId: user2.id!, postId: post2.id!)
        try await repository.create(comment2)

        let count = try await repository.all(forUserId: user1.id!).count
        XCTAssertEqual(count, 1)
    }
    
    func testAllForPost() async throws {
        let user1 = try UserAccountModel.mock(app: app, email: "test1@test.com")
        try await user1.create(on: app.db)
        
        let post1 = try PostModel.mock(user: user1)
        try await post1.create(on: app.db)
        
        let comment = CommentModel.mock(userId: user1.id!, postId: post1.id!)
        try await repository.create(comment)
        
        let comment2 = CommentModel.mock(userId: user1.id!, postId: post1.id!)
        try await repository.create(comment2)

        let count = try await repository.all(forPostId: post1.id!).count
        XCTAssertEqual(count, 2)
    }
}

extension CommentRepositoryTests {
    func createComment() async throws -> CommentModel {
        let user = try UserAccountModel.mock(app: app, email: "test\(Int.random())@test.com")
        try await user.create(on: app.db)
        
        let post = try PostModel.mock(user: user)
        try await post.create(on: app.db)
        
        let comment = CommentModel.mock(userId: user.id!, postId: post.id!)
        try await repository.create(comment)
        
        return comment
    }
}

@testable import App
import Fluent
import XCTVapor

final class PostRepositoryTests: XCTestCase {
    var app: Application!
    var repository: (any PostRepository)!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabasePostRepository(database: app.db)
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.migrator.revertAllBatches().wait()
        app.shutdown()
    }
    
    func testDefaultProvider() throws {
        let defaultProvider = app.repositories.posts
        XCTAssertTrue(type(of: defaultProvider) == DatabasePostRepository.self)
    }
    
    func testCreate() async throws {
        let model = try await createModel()
        let retrieved = try await repository.find(id: model.id!)
        XCTAssertNotNil(retrieved)
    }
    
    func testFindByID() async throws {
        let model = try await createModel()
        try await XCTAssertNotNilAsync(await repository.find(id: model.id!))
    }
    
    func testCount() async throws {
        let _ = try await createModel()
        let _ = try await createModel()
        
        let count = try await repository.count()
        XCTAssertEqual(count, 2)
    }
    
    func testDelete() async throws {
        let model = try await createModel()
        try await repository.delete(id: model.id!)
        
        let count = try await repository.count()
        XCTAssertEqual(count, 0)
    }
    
    func testAll() async throws {
        let _ = try await createModel()
        let _ = try await createModel()
        
        let all = try await repository.all()
        XCTAssertEqual(all.count, 2)
    }
    
    func testUpdate() async throws {
        let model = try await createModel()
        model.text = "New text"
        try await repository.update(model)
        
        let found = try await XCTUnwrapAsync(await repository.find(id: model.id!))
        XCTAssertEqual(found.text, "New text")
    }
    
    func testAllForUser() async throws {
        let user1 = try UserAccountModel.mock(app: app, email: "test1@test.com")
        try await user1.create(on: app.db)
        
        let post1 = try PostModel.mock(user: user1)
        try await repository.create(post1)
        
        let user2 = try UserAccountModel.mock(app: app, email: "test@test.com")
        try await user2.create(on: app.db)
        
        let post2 = try PostModel.mock(user: user2)
        try await repository.create(post2)
        
        let count = try await repository.all(forUserId: user1.id!).count
        XCTAssertEqual(count, 1)
    }
}

extension PostRepositoryTests {
    func createModel() async throws -> PostModel {
        let user = try UserAccountModel.mock(app: app, email: "test\(Int.random())@test.com")
        try await user.create(on: app.db)
        
        let model = try PostModel.mock(user: user)
        try await repository.create(model)
        
        return model
    }
}

@testable import App
import Fluent
import XCTVapor

final class MediaRepositoryTests: XCTestCase {
    var app: Application!
    var repository: (any MediaRepository)!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseMediaRepository(database: app.db)
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.migrator.revertAllBatches().wait()
        app.shutdown()
    }
    
    func testDefaultProvider() throws {
        let defaultProvider = app.repositories.media
        XCTAssertTrue(type(of: defaultProvider) == DatabaseMediaRepository.self)
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
    
    func testUpdate() async throws {
        let model = try await createModel()
        model.ext = "m4a"
        try await repository.update(model)
        
        let found = try await XCTUnwrapAsync(await repository.find(id: model.id!))
        XCTAssertEqual(found.ext, "m4a")
    }
}

extension MediaRepositoryTests {
    func createModel() async throws -> MediaModel {
        let model = MediaModel(id: .init(), type: "video", ext: "mp4", key: "video.mp4")
        try await repository.create(model)
        
        return model
    }
}

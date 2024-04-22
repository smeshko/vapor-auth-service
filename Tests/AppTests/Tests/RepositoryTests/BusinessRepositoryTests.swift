@testable import App
import Fluent
import XCTVapor

final class BusinessRepositoryTests: XCTestCase {
    var app: Application!
    var repository: DatabaseBusinessRepository!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseBusinessRepository(database: app.db)
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.autoRevert().wait()
        app.shutdown()
    }
    
    func testDefaultProvider() throws {
        let defaultProvider = app.repositories.businesses
        XCTAssertTrue(type(of: defaultProvider) == DatabaseBusinessRepository.self)
    }
    
    func testCreatingBusiness() async throws {
        let business = try await createBusiness()
        let retrieved = try await repository.find(id: business.id!)
        XCTAssertNotNil(retrieved)
    }
    
    func testDeletingBusiness() async throws {
        let business = try await createBusiness()
        let count = try await repository.count()
        XCTAssertEqual(count, 1)
        
        try await repository.delete(id: business.requireID())
        let countAfterDelete = try await repository.count()
        XCTAssertEqual(countAfterDelete, 0)
    }
    
    func testGetAllBusinesses() async throws {
        let _ = try await createBusiness()
        let _ = try await createBusiness()
        
        let all = try await repository.all()
        XCTAssertEqual(all.count, 2)
    }
    
    func testFindById() async throws {
        let business = try await createBusiness()
        let found = try await repository.find(id: business.requireID())
        XCTAssertNotNil(found)
    }


    func testUpdate() async throws {
        let business = try await createBusiness()
        business.name = "New Name"
        try await repository.update(business)

        let updated = try await repository.find(id: business.id!)
        XCTAssertEqual(updated!.name, "New Name")
    }
    
    func testCreateOpeningHours() async throws {
        let business = try await createBusinessWithOpeningHours()
        XCTAssertEqual(business.openingHours.count, 1)
    }
    
    func testCreateMultipleOpeningHours() async throws {
        let business = try await createBusinessWithOpeningHours(3)
        XCTAssertEqual(business.openingHours.count, 3)
    }

    func testUpdateOpeningHours() async throws {
        let business = try await createBusinessWithOpeningHours()
        let hours = try XCTUnwrap(business.openingHours.first)
        
        hours.day = "wed"
        try await repository.update(hours)
        
        let loaded = try await XCTUnwrapAsync(await repository.find(id: business.id!))
        XCTAssertEqual(loaded.openingHours.first?.day, "wed")

    }
}

private extension BusinessRepositoryTests {
    func createBusiness() async throws -> BusinessAccountModel {
        let user = UserAccountModel(email: "test\(Int.random())@test.com", password: "123")
        try await user.create(on: app.db)
        let business = BusinessAccountModel.mock(user: user, name: "Name \(Int.random())")
        try await repository.create(business)

        return business
    }
    
    func createBusinessWithOpeningHours(_ count: Int = 1) async throws -> BusinessAccountModel {
        let business = try await createBusiness()
        for _ in 0..<count {
            let hours = OpeningHoursModel.mock(business: business)
            try await repository.create(hours)
        }
        
        return try await XCTUnwrapAsync(await repository.find(id: business.id!))
    }
}

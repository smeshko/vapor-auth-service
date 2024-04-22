@testable import App
import Fluent
import XCTVapor

final class UserRepositoryTests: XCTestCase {
    var app: Application!
    var repository: DatabaseUserRepository!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseUserRepository(database: app.db)
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.autoRevert().wait()
        app.shutdown()
    }
    
    func testDefaultProvider() throws {
        let defaultProvider = app.repositories.users
        XCTAssertTrue(type(of: defaultProvider) == DatabaseUserRepository.self)
    }
    
    func testCreatingUser() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        try await repository.create(user)
        
        XCTAssertNotNil(user.id)
        
        let userRetrieved = try await UserAccountModel.find(user.id, on: app.db)
        XCTAssertNotNil(userRetrieved)
    }
    
    func testDeletingUser() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        try await user.create(on: app.db)
        let count = try await UserAccountModel.query(on: app.db).count()
        XCTAssertEqual(count, 1)
        
        try await repository.delete(id: user.requireID())
        let countAfterDelete = try await UserAccountModel.query(on: app.db).count()
        XCTAssertEqual(countAfterDelete, 0)
    }
    
    func testGetAllUsers() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        let user2 = UserAccountModel(email: "test2@test.com", password: "123")
        
        try await user.create(on: app.db)
        try await user2.create(on: app.db)
        
        let users = try await repository.all()
        XCTAssertEqual(users.count, 2)
    }
    
    func testFindUserById() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        try await user.create(on: app.db)
        
        let userFound = try await repository.find(id: user.requireID())
        XCTAssertNotNil(userFound)
    }
    
    func testFindByAppleID() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123", appleUserIdentifier: "1")
        try await user.create(on: app.db)
        
        try await XCTAssertNotNilAsync(try await repository.find(appleUserIdentifier: "1"))
    }

    func testFindByEmail() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123", appleUserIdentifier: "1")
        try await user.create(on: app.db)
        
        try await XCTAssertNotNilAsync(try await repository.find(email: "test@test.com"))
    }

    func testSetFieldValue() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123", isEmailVerified: false)
        try await user.create(on: app.db)
        user.isEmailVerified = true
        try await repository.update(user)
        
        let updatedUser = try await UserAccountModel.find(user.id!, on: app.db)
        XCTAssertEqual(updatedUser!.isEmailVerified, true)
    }
    
    func testSetLocation() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        try await user.create(on: app.db)
        
        let location = LocationModel.mock(userId: user.id!)
        try await repository.add(location, to: user)
        try await repository.loadLocation(for: user)
        
        XCTAssertNotNil(user.location)
    }
    
    func testUpdateLocation() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        try await user.create(on: app.db)
        
        let location = LocationModel.mock(userId: user.id!)
        try await repository.add(location, to: user)
        location.address = "New address"
        
        try await repository.update(location)
        try await repository.loadLocation(for: user)

        XCTAssertEqual(user.location?.address, "New address")
    }
    
    func testGetLocation() async throws {
        let user = UserAccountModel(email: "test@test.com", password: "123")
        try await user.create(on: app.db)
        
        let location = LocationModel.mock(userId: user.id!)
        try await repository.add(location, to: user)
        try await XCTAssertNotNilAsync(try await repository.getLocation(for: user))
    }
}

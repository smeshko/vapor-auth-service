@testable import App
import Entities
import Fluent
import XCTVapor
import Crypto

extension User.Update.Request: Content {}

final class UserPatchTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    var request: User.Update.Request!
    let patchPath = "api/user/update"

    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
        request = .init(
            email: "new_mail@test.com",
            firstName: "New",
            lastName: "name",
            location: .mock()
        )
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testPatchHappyPath() async throws {
        try await app.repositories.users.create(user)
                
        try await app.test(.PATCH, patchPath, user: user, content: request) { res in
            XCTAssertContent(User.Update.Response.self, res) { patchContent in
                XCTAssertEqual(patchContent.email, "new_mail@test.com")
                XCTAssertEqual(patchContent.firstName, "New")
                XCTAssertEqual(patchContent.lastName, "name")
                XCTAssertEqual(patchContent.location, Location.mock())
            }
        }
    }
    
    func testPatchNotLoggedIn() async throws {
        try await app.test(.PATCH, patchPath, content: request) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
    
    func testPatchUpdateLocationIfExisting() async throws {
        try await app.repositories.users.create(user)
        let location = LocationModel.mock(userId: user.id!)
        try await app.repositories.users.add(location, to: user)

        request = .init(
            location: .mock(city: "City")
        )
        
        try await app.test(.PATCH, patchPath, user: user, content: request) { res in
            XCTAssertContent(User.Update.Response.self, res) { patchContent in
                XCTAssertEqual(patchContent.location?.city, "City")
            }
        }
    }
}

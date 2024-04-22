@testable import App
import Entities
import Fluent
import XCTVapor

final class UserListTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let listPath = "api/user/list"
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app, isAdmin: true)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testListHappyPath() async throws {
        try await app.repositories.users.create(user)
        try await app.test(.GET, listPath, user: user) { response in
            XCTAssertContent([User.List.Response].self, response) { listResponse in
                XCTAssertEqual(listResponse.count, 1)
            }
        }
    }
    
    func testListRequestedByNonAdminShouldFail() async throws {
        let nonAdmin = try UserAccountModel.mock(app: app)
        try await app.repositories.users.create(nonAdmin)
        
        try await app.test(.GET, listPath, user: nonAdmin) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
    
    func testListUnauthenticatedRequestShouldFail() async throws {
        try app.test(.GET, listPath) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
}

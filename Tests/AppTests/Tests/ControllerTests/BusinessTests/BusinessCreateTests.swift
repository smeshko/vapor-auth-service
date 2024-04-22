@testable import App
import Common
import Entities
import Fluent
import XCTVapor

extension Business.Create.Request: Content {}

final class BusinessCreateTests: XCTestCase {
    var app: Application!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let path = "api/business/sign-up"
    var request: Business.Create.Request!
    let uuid = UUIDGenerator.incrementing
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        let id = uuid()
        user = try UserAccountModel.mock(app: app, id: id)
        request = .mock(userID: id)
    }
    
    func testHappyPath() async throws {
        try await app.repositories.users.create(user)
        
        try await app.test(.POST, path, user: user, content: request) { response in
            try await XCTAssertContentAsync(Business.Create.Response.self, response) { response in
                XCTAssertEqual(response.name, request.name)
                XCTAssertEqual(response.userID, user.id!)
                XCTAssertEqual(response.industry, request.industry)
                XCTAssertEqual(response.website, request.website)
                XCTAssertEqual(response.phone, request.phone)
                XCTAssertEqual(response.contactEmail, request.email)
                XCTAssertEqual(response.description, request.description)
                XCTAssertEqual(response.openingTimes, request.openingTimes)
                XCTAssertEqual(response.photoIds, request.photoIds)
                XCTAssertEqual(response.avatarId, request.avatarId)
                
                let businessModel = try await app.repositories.businesses.find(id: response.id)
                XCTAssertGreaterThan(businessModel!.openingHours.count, 0)
                XCTAssertEqual(businessModel?.isVerified, request.isVerified)
                
                let count = try await app.repositories.businesses.count()
                XCTAssertEqual(count, 1)
            }
        }
    }
    
    func testCreateNotLoggedIn() async throws {
        try await app.test(.POST, path, content: request) { response in
            XCTAssertEqual(response.status, .unauthorized)
        }
    }
}

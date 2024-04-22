@testable import App
import Common
import Entities
import Fluent
import XCTVapor

final class PlacesNearbyTests: XCTestCase {
    var app: Application!
    var post: PostModel!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let path = "api/services/places/search?latitude=1&longitude=3"
    let uuid = UUIDGenerator.incrementing
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        testWorld = try TestWorld(app: app)
        
        user = try UserAccountModel.mock(app: app)
    }
    
    override func tearDown() {
        super.tearDown()
        app.shutdown()
    }
    
    func testNearbyHappyPath() async throws {
        let response: GooglePlacesSearchResponse = .mock()
        
        app.clients.use(.fake(response) { request in
            XCTAssertEqual(request.url.string, "https://places.googleapis.com/v1/places:searchNearby")
            XCTAssertTrue(request.headers.contains(name: "X-Goog-Api-Key"))
            XCTAssertTrue(request.headers.contains(name: "X-Goog-FieldMask"))

            let requestBody = try! request.content.decode(GooglePlacesSearchRequest.self)
            XCTAssertEqual(requestBody.includedTypes, [.restaurant])
            XCTAssertEqual(requestBody.locationRestriction.circle.center.latitude, 1)
            XCTAssertEqual(requestBody.locationRestriction.circle.center.longitude, 3)
        })
        
        try app.test(.GET, path) { response in
            XCTAssertContent(Places.Search.Response.self, response) { response in
                XCTAssertEqual(response.places.count, 1)
            }
        }
    }
    
    func testNearbyUsesTypeIfProvided() async throws {
        let response: GooglePlacesSearchResponse = .mock()
        
        app.clients.use(.fake(response) { request in
            XCTAssertEqual(request.url.string, "https://places.googleapis.com/v1/places:searchNearby")
            XCTAssertTrue(request.headers.contains(name: "X-Goog-Api-Key"))
            XCTAssertTrue(request.headers.contains(name: "X-Goog-FieldMask"))
            
            let requestBody = try! request.content.decode(GooglePlacesSearchRequest.self)
            XCTAssertEqual(requestBody.includedTypes, [.address])
            XCTAssertEqual(requestBody.locationRestriction.circle.center.latitude, 1)
            XCTAssertEqual(requestBody.locationRestriction.circle.center.longitude, 3)
        })
        
        try app.test(.GET, "\(path)&type=street_address") { response in
            XCTAssertContent(Places.Search.Response.self, response) { response in
                XCTAssertEqual(response.places.count, 1)
            }
        }
    }
}

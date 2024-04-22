@testable import App
import Common
import Entities
import Fluent
import XCTVapor

final class PlacesGeocodeTests: XCTestCase {
    var app: Application!
    var post: PostModel!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let geocodePath = "api/services/places/geocode?placeId=id"
    let reverseGeocodePath = "api/services/places/reverse-geocode?latitude=1&longitude=2"
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
    
    func testGeocodeHappyPath() async throws {
        let response: GoogleMapsGeocodingResponse = .mock()
        
        app.clients.use(.fake(response) { request in
            XCTAssertEqual(request.url.string, "https://maps.googleapis.com/maps/api/geocode/json?place_id=id&key=\(Environment.placesKey)")
        })
        
        try app.test(.GET, geocodePath) { response in
            XCTAssertContent(Places.Geocode.Response.self, response) { response in
                XCTAssertEqual(response.placeId, "1")
            }
        }
    }
    
    func testReverseGeocodeHappyPath() async throws {
        let response: GoogleMapsGeocodingResponse = .mock()
        
        app.clients.use(.fake(response) { request in
            XCTAssertEqual(request.url.string, "https://maps.googleapis.com/maps/api/geocode/json?latlng=1.0,2.0&result_type=street_address&key=\(Environment.placesKey)")
        })

        try app.test(.GET, reverseGeocodePath) { response in
            XCTAssertContent([Places.Geocode.Response].self, response) { response in
                XCTAssertEqual(response.first!.placeId, "1")
            }
        }
    }
}

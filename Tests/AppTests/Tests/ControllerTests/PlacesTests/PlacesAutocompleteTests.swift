@testable import App
import Common
import Entities
import Fluent
import XCTVapor

final class PlacesAutocompleteTests: XCTestCase {
    var app: Application!
    var post: PostModel!
    var user: UserAccountModel!
    var testWorld: TestWorld!
    let path = "api/services/places/autocomplete?query=Drin"
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
    
    func testAutocompleteHappyPath() async throws {
        let response: GooglePlacesAutocompleteResponse = .mock()
        
        app.clients.use(.fake(response) { request in
            XCTAssertEqual(request.url.string, "https://places.googleapis.com/v1/places:autocomplete")
            XCTAssertTrue(request.headers.contains(name: "X-Goog-Api-Key"))

            let requestBody = try! request.content.decode(GooglePlacesAutocompleteRequest.self)
            XCTAssertEqual(requestBody.input, "Drin")
            XCTAssertNil(requestBody.locationBias)
        })
        
        try app.test(.GET, path) { response in
            XCTAssertContent(Places.Autocomplete.Response.self, response) { response in
                XCTAssertEqual(response.suggestions.count, 1)
            }
        }
    }
    
    func testAutocompleteUsesLocationIfProvided() async throws {
        let response: GooglePlacesAutocompleteResponse = .mock()
        
        app.clients.use(.fake(response) { request in
            XCTAssertEqual(request.url.string, "https://places.googleapis.com/v1/places:autocomplete")
            XCTAssertTrue(request.headers.contains(name: "X-Goog-Api-Key"))
            
            let requestBody = try! request.content.decode(GooglePlacesAutocompleteRequest.self)
            XCTAssertEqual(requestBody.input, "Drin")
            XCTAssertNotNil(requestBody.locationBias)
        })
        
        try app.test(.GET, "\(path)&lat=1&lon=2") { response in
            XCTAssertContent(Places.Autocomplete.Response.self, response) { response in
                XCTAssertEqual(response.suggestions.count, 1)
            }
        }
    }
}

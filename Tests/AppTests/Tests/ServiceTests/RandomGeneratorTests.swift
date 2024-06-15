@testable import App
import XCTVapor
import Common
import Testing

struct _RandomGeneratorTests {
    let app: Application
    let testWorld: TestWorld
    
    init() throws {
        self.app = Application(.testing)
        try configure(app)
        self.testWorld = try .init(app: app)
    }
    
    @Test
    func defaultProvider() throws {
        let defaultGenerator = app.random.generator
        #expect(type(of: defaultGenerator) == RealRandomGenerator.self)
    }

}

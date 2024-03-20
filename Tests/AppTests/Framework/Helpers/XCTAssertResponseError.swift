@testable import App
import Common
import XCTVapor

func XCTAssertResponseError(_ res: XCTHTTPResponse, _ error: AppError, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(res.status, error.status, file: file, line: line)
    XCTAssertContent(ErrorResponse.self, res) { errorContent in
        XCTAssertEqual(errorContent.errorIdentifier, error.identifier, file: file, line: line)
        XCTAssertEqual(errorContent.reason, error.reason, file: file, line: line)
    }
}

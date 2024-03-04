import XCTVapor

func XCTAssertNotNilAsync(_ expression: @autoclosure () async throws -> Any?) async throws {
    let result = try await expression()
    XCTAssertNotNil(result)
}

func XCTUnwrapAsync<T>(_ expression: @autoclosure () async throws -> T?) async throws -> T {
    let result = try await expression()
    return try XCTUnwrap(result)
}

public func XCTAssertContentAsync<D>(
    _ type: D.Type,
    _ res: XCTHTTPResponse,
    file: StaticString = #file,
    line: UInt = #line,
    _ closure: (D) async throws -> ()
)
    async rethrows
    where D: Decodable
{
    guard let contentType = res.headers.contentType else {
        XCTFail("response does not contain content type", file: (file), line: line)
        return
    }

    let content: D

    do {
        let decoder = try ContentConfiguration.global.requireDecoder(for: contentType)
        content = try decoder.decode(D.self, from: res.body, headers: res.headers)
    } catch {
        XCTFail("could not decode body: \(error)", file: (file), line: line)
        return
    }

    try await closure(content)
}

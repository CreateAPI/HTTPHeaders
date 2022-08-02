import XCTest
@testable import HTTPHeaders

final class HTTPHeadersTests: XCTestCase {
    func testParseString() throws {
        // Given
        let response = makeResponse(headers: ["X-RateLimit-Reset": "2015-01-01T00:00:00Z"])
        let header = HTTPHeader<String>(field: "X-RateLimit-Reset")
        
        // When/Then
        let value = try header.parse(from: response)
        XCTAssertEqual(value, "2015-01-01T00:00:00.000Z")
    }
    
    func testParseOptionalString() throws {
        // Given
        let response = makeResponse(headers: ["X-RateLimit-Reset": "2015-01-01T00:00:00Z"])
        let header = HTTPHeader<String>(field: "non-existing-key")
        
        // When/Then
        let value = try header.parseIfPresent(from: response)
        XCTAssertNil(value)
    }
    
    func testParseDate() throws {
        // Given
        let response = makeResponse(headers: ["X-RateLimit-Reset": "2015-01-01T00:00:00Z"])
        let header = HTTPHeader<Date>(field: "X-RateLimit-Reset")
        
        // When/Then
        let value = try header.parse(from: response)
        XCTAssertEqual(value, Date.init(timeIntervalSinceReferenceDate: 441763200.0))
    }
    
    func testParseDateWithCustomOptions() throws {
        // Given
        let response = makeResponse(headers: ["X-RateLimit-Reset": "2015-01-01T01:20:30.25Z"])
        let header = HTTPHeader<Date>(field: "X-RateLimit-Reset", options: [.withInternetDateTime, .withFractionalSeconds])

        // When/Then
        let value = try header.parse(from: response)
        print(value.timeIntervalSinceReferenceDate)
        XCTAssertEqual(value, Date.init(timeIntervalSinceReferenceDate: 441768030.25))
    }
    
    private func makeResponse(headers: [String: String]) -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://api.github.com/user")!, statusCode: 200, httpVersion: nil, headerFields: headers)!
    }
}

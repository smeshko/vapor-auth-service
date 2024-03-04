import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

/// An object that represents an API endpoint. Contains all properties needed to build a request to an endpoint.
public protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var url: URL? { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String]? { get }
}

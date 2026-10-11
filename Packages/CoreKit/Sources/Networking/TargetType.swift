import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol TargetType {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var sampleData: Data { get }
}

public extension TargetType {
    // Most endpoints have no query, so a default saves boilerplate.
    var queryItems: [URLQueryItem] { [] }
}

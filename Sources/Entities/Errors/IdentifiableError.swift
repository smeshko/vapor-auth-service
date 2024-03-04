import Foundation

public protocol IdentifiableError {
    var identifier: String { get }
    var reason: String { get }
}

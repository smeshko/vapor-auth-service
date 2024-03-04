import Foundation

public extension Collection {
    func take(_ count: Int) -> Array<Element> {
        Array(prefix(count))
    }
}

import Foundation

public extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }
        
        return self[index]
    }
}

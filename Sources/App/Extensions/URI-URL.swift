import Foundation
import Vapor

extension URI {
    init(url: URL) {
        self.init(string: url.absoluteString)
    }
}

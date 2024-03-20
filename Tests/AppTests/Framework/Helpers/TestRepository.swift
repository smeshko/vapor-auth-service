@testable import App
import Common
import Vapor

protocol TestRepository: AnyObject {}

extension TestRepository where Self: RequestService {
    func `for`(_ req: Request) -> Self {
        return self
    }
}

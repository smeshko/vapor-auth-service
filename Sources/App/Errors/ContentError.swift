import Common
import Entities
import Vapor

extension ContentError: AppError {}

extension ContentError: AbortError {
    public var status: HTTPResponseStatus {
        switch self {
        case .contentNotFound:
            .notFound
        }
    }
}

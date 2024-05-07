import Common
import Entities
import Vapor

extension UserError: AppError {}

extension UserError: AbortError {
    public var status: HTTPResponseStatus {
        switch self {
        case .userNotFound: .notFound
        case .userAlreadyFollowsUser: .badRequest
        case .userNotFollowingUser: .badRequest
        }
    }
}

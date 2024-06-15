import Common
import Entities
import Vapor

extension UserError: @retroactive DebuggableError {}
extension UserError: @retroactive CustomStringConvertible {}
extension UserError: @retroactive CustomDebugStringConvertible {}
extension UserError: @retroactive LocalizedError {}
extension UserError: @retroactive AppError {}

extension UserError: @retroactive AbortError {
    public var status: HTTPResponseStatus {
        switch self {
        case .userNotFound: .notFound
        case .userAlreadyFollowsUser: .badRequest
        case .userNotFollowingUser: .badRequest
        }
    }
}

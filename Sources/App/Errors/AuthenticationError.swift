import Common
import Entities
import Vapor

extension AuthenticationError: AppError {}

extension AuthenticationError: AbortError {
    public var status: HTTPResponseStatus {
        switch self {
        case .passwordsDontMatch:
            return .badRequest
        case .emailAlreadyExists:
            return .badRequest
        case .emailTokenHasExpired:
            return .badRequest
        case .invalidEmailOrPassword:
            return .unauthorized
        case .refreshTokenOrUserNotFound:
            return .notFound
        case .userNotAuthorized:
            return .unauthorized
        case .emailTokenNotFound:
            return .notFound
        case .refreshTokenHasExpired:
            return .unauthorized
        case .accessTokenHasExpired:
            return .unauthorized
        case .emailIsNotVerified:
            return .unauthorized
        case .invalidPasswordToken:
            return .notFound
        case .passwordTokenHasExpired:
            return .unauthorized
        case .emailVerificationFailed:
            return .badRequest
        case .passwordResetFailed:
            return .badRequest
        }
    }
}

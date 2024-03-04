import Foundation

public enum AuthenticationError: String, IdentifiableError {
    case passwordsDontMatch = "passwords_dont_match"
    case emailAlreadyExists = "email_already_exists"
    case invalidEmailOrPassword = "invalid_email_or_password"
    case refreshTokenOrUserNotFound = "refresh_token_or_user_not_found"
    case refreshTokenHasExpired = "refresh_token_has_expired"
    case accessTokenHasExpired = "access_token_has_expired"
    case userNotFound = "user_not_found"
    case userNotAuthorized = "user_not_authorized"
    case emailTokenHasExpired = "email_token_has_expired"
    case emailTokenNotFound = "email_token_not_found"
    case emailIsNotVerified = "email_is_not_verified"
    case invalidPasswordToken = "invalid_password_token"
    case passwordTokenHasExpired = "password_token_has_expired"
    case emailVerificationFailed = "email_verification_failed"
    case passwordResetFailed = "password_reset_failed"
    
    public var identifier: String {
        rawValue
    }
    
    public var reason: String {
        switch self {
        case .passwordsDontMatch:
            return "Passwords did not match"
        case .emailAlreadyExists:
            return "A user with that email already exists"
        case .invalidEmailOrPassword:
            return "Email or password was incorrect"
        case .refreshTokenOrUserNotFound:
            return "User or refresh token was not found"
        case .accessTokenHasExpired:
            return "Access token has expired"
        case .refreshTokenHasExpired:
            return "Refresh token has expired"
        case .userNotFound:
            return "User was not found"
        case .userNotAuthorized:
            return "User is not authorized for the requested action"
        case .emailTokenNotFound:
            return "Email token not found"
        case .emailTokenHasExpired:
            return "Email token has expired"
        case .emailIsNotVerified:
            return "Email is not verified"
        case .invalidPasswordToken:
            return "Invalid reset password token"
        case .passwordTokenHasExpired:
            return "Reset password token has expired"
        case .emailVerificationFailed:
            return "Email verification failed"
        case .passwordResetFailed:
            return "Password reset failed"
        }
    }
}

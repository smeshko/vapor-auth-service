import Entities
import Vapor

extension Auth.Login.Request: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty)
    }
}

extension Auth.SignUp.Request: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension Auth.PasswordReset.Request: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("password", as: String.self, is: !.empty)
        validations.add("token", as: String.self, is: !.empty)
    }
}

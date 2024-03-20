import Common
import Entities
import Vapor

struct PasswordResetter {
    let repository: any PasswordTokenRepository
    let generator: RandomGenerator
    let application: Application

    /// Sends a email to the user with a reset-password URL
    func reset(for user: UserAccountModel) async throws {
        
        let token = generator.generate(bits: 256)
        let resetPasswordToken = try PasswordTokenModel(userID: user.requireID(), value: SHA256.hash(token))
        try await repository.create(resetPasswordToken)
        
        let content = BrevoMail(
            sender: .init(
                name: "Sender",
                email: "noreply@sender.com"
            ),
            to: [.init(
                name: user.fullName,
                email: user.email
            )],
            subject: "Password reset request",
            htmlContent: Templates.passwordReset(token: resetPasswordToken.value)
        )
        
        try await application.email.client().send(content)
    }
}

extension Request {
    var passwordResetter: PasswordResetter {
        .init(
            repository: passwordTokens,
            generator: application.random,
            application: application
        )
    }
}

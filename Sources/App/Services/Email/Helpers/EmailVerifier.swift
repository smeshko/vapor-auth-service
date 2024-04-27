import Common
import Entities
import Vapor

struct EmailVerifier {
    let emailTokenRepository: any EmailTokenRepository
    let generator: RandomGenerator
    let application: Application
    
    func verify(for user: UserAccountModel) async throws {
        let token = generator.generate(bits: 256)
        let emailToken = try EmailTokenModel(userID: user.requireID(), value: SHA256.hash(token))
        try await emailTokenRepository.create(emailToken)
        
        let content = BrevoMail(
            sender: .init(
                name: "Sender",
                email: "noreply@sender.com"
            ),
            to: [.init(
                name: "\(user.firstName ?? "") \(user.lastName ?? "")",
                email: user.email
            )],
            subject: "Verify your account",
            htmlContent: Templates.verifyEmail(token: emailToken.value)
        )
        
        try await application.services.email.service.send(content)
    }
}

extension Application {
    var emailVerifier: EmailVerifier {
        .init(
            emailTokenRepository: repositories.emailTokens,
            generator: random,
            application: self
        )
    }
}

extension Request {
    var emailVerifier: EmailVerifier {
        .init(
            emailTokenRepository: repositories.emailTokens,
            generator: application.random,
            application: application
        )
    }
}

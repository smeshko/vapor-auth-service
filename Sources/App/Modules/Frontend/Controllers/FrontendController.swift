import Entities
import Vapor
import Fluent

struct FrontendController {
    func verifyEmail(_ req: Request) async throws -> Response {
        let token = try req.query.get(String.self, at: "token")
        
        guard let token = try await req.emailTokens.find(token: token) else {
            return req.templates.renderHtml(OutcomeMessageTemplate(.init(
                text: "Token not found, please request verification again.", 
                title: "Token not found"
            )))
        }
        
        try await req.emailTokens.delete(id: token.requireID())
        
        guard token.expiresAt > .now else {
            return req.templates.renderHtml(OutcomeMessageTemplate(.init(
                text: "Token expired, please request verification again.",
                title: "Token expired"
            )))
        }
        
        token.user.isEmailVerified = true
        try await req.users.update(token.user)

        return req.templates.renderHtml(OutcomeMessageTemplate(.init(
            text: "Email successfully verified!",
            title: "Success"
        )))
    }
    
    func resetPassword(_ req: Request) async throws -> Response {
        let token = try req.query.get(String.self, at: "token")
        
        guard let token = try await req.passwordTokens.find(token: token) else {
            return req.templates.renderHtml(OutcomeMessageTemplate(.init(
                text: "Token not found, please request password reset again.",
                title: "Token not found"
            )))
        }

        guard token.expiresAt > .now else {
            return req.templates.renderHtml(OutcomeMessageTemplate(.init(
                text: "Token expired, please request password reset again.",
                title: "Token expired"
            )))
        }
        
        return renderResetPasswordView(req, .init(token: token.value))
    }
    
    func resetPasswordAction(_ req: Request) async throws -> Response {
        let input = try req.content.decode(PasswordResetInput.self)
        let token = try req.query.get(String.self, at: "token")
        
        guard let token = try await req.passwordTokens.find(token: token) else {
            return req.templates.renderHtml(OutcomeMessageTemplate(.init(
                text: "Token not found, please request password reset again.",
                title: "Token not found"
            )))
        }

        guard input.password == input.confirmPassword else {
            let form = try await createResetPasswordForm(
                withCustomErrorMessage: "Passwords don't match",
                req, token: token.value
            )
            return renderResetPasswordView(req, form)
        }
        
        try await req.passwordTokens.delete(id: token.requireID())
        let hash = try await req.password.async.hash(input.password)
        token.user.password = hash
        try await req.users.update(token.user)

        return req.templates.renderHtml(OutcomeMessageTemplate(.init(
            text: "Password successfully changed!",
            title: "Success"
        )))
    }
    
    private func renderResetPasswordView(
        _ req: Request,
        _ form: ResetPasswordForm
    ) -> Response {
        let template = ResetPasswordTemplate(
            .init(
                title: "Reset password",
                message: "Enter new password",
                form: form.render(req: req)
            )
        )
        
        return req.templates.renderHtml(template)
    }
    
    private func createResetPasswordForm(
        withCustomErrorMessage message: String? = nil,
        _ req: Request,
        token: String
    ) async throws -> ResetPasswordForm {
        let form = ResetPasswordForm(token: token)
        try await form.process(req: req)
        let isValid = try await form.validate(req: req)
        
        if let message {
            form.error = message
        } else if !isValid {
            form.error = "Password requirements not met"
        }
        return form
    }
}

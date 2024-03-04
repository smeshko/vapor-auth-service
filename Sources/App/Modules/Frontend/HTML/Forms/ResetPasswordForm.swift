import Vapor

final class ResetPasswordForm: AbstractForm {
    
    public convenience init(token: String) {
        self.init(
            action: .init(
                method: .post,
                url: "/reset-password?token=\(token)"
            ),
            submit: "Reset password"
        )
        self.fields = createFields()
    }

    @FormComponentBuilder
    func createFields() -> [FormComponent] {
        InputField("password")
            .config {
                $0.output.context.label.required = true
                $0.output.context.type = .password
            }
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator.min($1, length: 8)
            }
        InputField("confirm_password", title: "Confirm password")
            .config {
                $0.output.context.label.required = true
                $0.output.context.type = .password
            }
            .validators {
                FormFieldValidator.required($1)
                FormFieldValidator.min($1, length: 8)
            }
    }
}

import Vapor
import SwiftHtml

struct ResetPasswordTemplate: TemplateRepresentable {

    var context: ResetPasswordContext
    
    init(
        _ context: ResetPasswordContext
    ) {
        self.context = context
    }

    @TagBuilder
    func render(
        _ req: Request
    ) -> Tag {
        WebIndexTemplate(
            .init(title: context.title)
        ) {
            Div {
                Section {
                    H1(context.title)
                    P(context.message)
                }
                .class("lead")

                context.form.render(req)
            }
            .id("reset-password")
            .class("container")
        }
        .render(req)
    }
}

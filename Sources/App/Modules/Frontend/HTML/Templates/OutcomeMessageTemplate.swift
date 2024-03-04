import Vapor
import SwiftHtml

struct OutcomeMessageTemplate: TemplateRepresentable {
    
    var context: OutcomeMessageContext
    
    init(
        _ context: OutcomeMessageContext
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
            Text(context.text)
        }
        .render(req)
    }
}

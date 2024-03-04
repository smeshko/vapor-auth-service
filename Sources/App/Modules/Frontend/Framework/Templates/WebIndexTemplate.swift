import Vapor
import SwiftHtml
import SwiftSvg

public struct WebIndexTemplate: TemplateRepresentable {

    public var context: WebIndexContext
    var body: Tag

    public init(
        _ context: WebIndexContext,
        @TagBuilder _ builder: () -> Tag
    ) {
        self.context = context
        self.body = builder()
    }

    @TagBuilder
    public func render(
        _ req: Request
    ) -> Tag {
        Html {
            Head {
                Meta()
                    .charset("utf-8")
                Meta()
                    .name(.viewport)
                    .content("width=device-width, initial-scale=1")

                Link(rel: .stylesheet)
                    .href("https://cdn.jsdelivr.net/gh/feathercms/feather-core@1.0.0-beta.44/feather.min.css")
                Link(rel: .stylesheet)
                    .href("/css/web.css")
                
                Title(context.title)
            }
            Body {
                Main {
                    body
                }

                Footer {
                    Section {
                        P {
                            Text("This site is powered by ")
                            A("Swift")
                                .href("https://swift.org")
                                .target(.blank)
                            Text(" & ")
                            A("Vapor")
                                .href("https://vapor.codes")
                                .target(.blank)
                            Text(".")
                        }
                    }
                }
                
                Script()
                    .type(.javascript)
                    .src("/js/web.js")
            }
        }
        .lang("en-US")
    }
}

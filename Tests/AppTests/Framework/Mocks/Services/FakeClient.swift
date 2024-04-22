import Vapor

struct FakeClient<Response: Content>: Client where Response: Sendable {
    let application: Application
    let response: Response
    let beforeRequest: @Sendable (ClientRequest) -> Void

    var eventLoop: any EventLoop {
        application.eventLoopGroup.next()
    }
    
    func delegating(to eventLoop: any NIOCore.EventLoop) -> any Client {
        self
    }
    
    func send(_ request: ClientRequest) -> EventLoopFuture<ClientResponse> {
        beforeRequest(request)
        return eventLoop.makeSucceededFuture(
            ClientResponse(
                status: .ok,
                headers: request.headers,
                body: .init(data: try! JSONEncoder().encode(response))
            )
        )
    }
}

extension Application.Clients.Provider {
    static func fake<Response: Content>(
        _ response: Response,
        beforeRequest: @Sendable @escaping (ClientRequest) -> Void
    ) -> Self {
        .init {
            $0.clients.use {
                FakeClient(
                    application: $0,
                    response: response,
                    beforeRequest: beforeRequest
                )
            }
        }
    }
}

import Vapor
import Entities

extension Application.Service.Provider where ServiceType == EmailService {
    static var brevo: Self {
        .init {
            $0.services.email.use { BrevoClient(app: $0) }
        }
    }
}

struct BrevoClient: EmailService {
    let app: Application
    
    func `for`(_ request: Request) -> any EmailService {
        Self.init(app: request.application)
    }
    
    @discardableResult
    func send(_ email: any Email) async throws -> HTTPStatus {
        let response = try await app.client.post(
            mailURI,
            headers: .init([
                ("accept", "application/json"),
                ("api-key", Environment.mailProviderKey),
                ("content-type", "application/json")
            ]),
            content: email
        )
        
        return response.status
    }
    
    private var mailURI: URI {
        URI(string: Environment.mailProviderUrl)
    }
}

import Vapor
import Entities

struct BrevoClient: EmailProvider {
    let app: Application
    
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
        
        if ![HTTPStatus.ok, .created].contains(response.status)  {
            throw AuthenticationError.emailVerificationFailed
        }
        
        return .ok
    }
    
    private var mailURI: URI {
        URI(string: Environment.mailProviderUrl)
    }
}

extension Application.Email.Provider {
    public static var brevo: Self {
        .init {
            $0.email.use(BrevoClient.init(app:))
        }
    }
}

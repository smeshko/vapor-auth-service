import Vapor

protocol EmailService {
    @discardableResult
    func send(_ email: any Email) async throws -> HTTPStatus
    
    func `for`(_ request: Request) -> EmailService
}

extension Application.Services {
    var email: Application.Service<EmailService> {
        .init(application: application)
    }
}

extension Request.Services {
    var email: EmailService {
        self.request.application.services.email.service.for(request)
    }
}

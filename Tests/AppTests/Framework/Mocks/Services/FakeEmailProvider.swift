import XCTVapor
@testable import App

struct FakeEmailProvider: EmailService {
    func `for`(_ request: Request) -> any EmailService {
        Self.init()
    }
    
    func send(_ email: any Email) async throws -> HTTPStatus {
        .ok
    }
}

extension Application.Service.Provider where ServiceType == EmailService {
    static var fake: Self {
        .init {
            $0.services.email.use { _ in
                FakeEmailProvider()
            }
        }
    }
}

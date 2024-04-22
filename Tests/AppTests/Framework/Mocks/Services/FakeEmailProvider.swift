import XCTVapor
@testable import App

struct FakeEmailProvider: EmailProvider {
    func send(_ email: any Email) async throws -> HTTPStatus {
        .ok
    }
}

extension Application.Email.Provider {
    static var fake: Self {
        .init {
            $0.email.use { _ in
                FakeEmailProvider()
            }
        }
    }
}

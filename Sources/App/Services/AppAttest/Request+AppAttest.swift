import Vapor

extension Request {
    var appAttest: AttestationService {
        self.application.appAttest
    }
}

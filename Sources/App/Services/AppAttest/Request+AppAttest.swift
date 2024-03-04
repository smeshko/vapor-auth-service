import Vapor

extension Request {
    var appAttest: AttestationService {
        application.appAttest
    }
}

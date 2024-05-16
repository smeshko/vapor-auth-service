import Vapor
import Entities

public protocol APNSService {
    func `for`(_ request: Request) -> APNSService
    
    func setup() throws
    
    func sendPushNotification(
        title: String,
        body: String,
        token: String,
        payload: NotificationPayload
    ) async throws
}

extension Application.Services {
    var apns: Application.Service<APNSService> {
        .init(application: application)
    }
}

extension Request.Services {
    var apns: APNSService {
        request.application.services.apns.service.for(request)
    }
}

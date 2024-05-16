import Entities
import Vapor

struct NotificationsController {
    
    func sendTestPush(_ req: Request) async throws -> HTTPStatus {
        let deviceId = try req.parameters.require("deviceID", as: UUID.self)
        
        guard let device = try await req.repositories.devices.find(id: deviceId) else {
            throw ContentError.deviceNotFound
        }
        
        guard let token = device.pushToken else {
            throw ContentError.deviceMissingToken
        }
        
        try await req.services.apns.sendPushNotification(
            title: "Hello",
            body: "This is a test notification",
            token: token,
            payload: NotificationPayload(
                path: .post,
                postId: .init(uuidString: "1ab351e3-6076-4c8f-9de5-4b9e13a184d6")
            )
        )

        return .ok
    }
}

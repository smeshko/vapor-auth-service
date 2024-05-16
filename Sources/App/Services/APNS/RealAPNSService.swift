import APNS
import APNSCore
import Entities
import Vapor
import VaporAPNS

extension Application.Service.Provider where ServiceType == APNSService {
    static var live: Self {
        .init {
            $0.services.apns.use { RealAPNSService(app: $0) }
        }
    }
}

struct RealAPNSService: APNSService {
    let app: Application
    
    func setup() throws {
        let apnsConfig = APNSClientConfiguration(
            authenticationMethod: .jwt(
                privateKey: try .loadFrom(string: Environment.apnsPrivateKey),
                keyIdentifier: Environment.apnsKey,
                teamIdentifier: Environment.apnsTeamId
            ),
            environment: app.environment == .production ? .production : .sandbox
        )
        app.apns.containers.use(
            apnsConfig,
            eventLoopGroupProvider: .shared(app.eventLoopGroup),
            responseDecoder: JSONDecoder(),
            requestEncoder: JSONEncoder(),
            as: .default
        )
    }
    
    func `for`(_ request: Request) -> any APNSService {
        Self.init(app: request.application)
    }
    
    func sendPushNotification(
        title: String,
        body: String,
        token: String,
        payload: NotificationPayload
    ) async throws {
        let alert = APNSAlertNotification(
            alert: .init(
                title: .raw(title),
                body: .raw(body)
            ),
            expiration: .immediately,
            priority: .immediately,
            topic: Environment.appIdentifier,
            payload: payload
        )
        
        try await app.apns.client.sendAlertNotification(alert, deviceToken: token)
    }
}

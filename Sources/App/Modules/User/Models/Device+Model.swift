import Entities
import Vapor

extension Device.Detail.Response: Content {}

extension Device.Detail.Response {
    init(from model: DeviceModel) throws {
        try self.init(
            id: model.requireID(),
            system: Device.System(rawValue: model.system) ?? .unknown,
            osVersion: model.osVersion,
            pushToken: model.pushToken
        )
    }
}

import Common
import Entities
import Vapor

struct DeviceController {
    func create(_ req: Request) async throws -> Device.Detail.Response {
        let request = try req.content.decode(Device.Create.Request.self)
        let user = try req.auth.require(UserAccountModel.self)
        
        let model = try DeviceModel(
            userId: user.requireID(),
            system: request.system.rawValue,
            osVersion: request.osVersion,
            pushToken: request.pushToken
        )
        
        try await req.repositories.devices.create(model)
        
        return try .init(from: model)
    }
    
    func patch(_ req: Request) async throws -> Device.Detail.Response {
        let request = try req.content.decode(Device.Update.Request.self)
        let deviceId = try req.parameters.require("deviceID", as: UUID.self)

        guard let device = try await req.repositories.devices.find(id: deviceId) else {
            throw ContentError.deviceNotFound
        }

        if let osVersion = request.osVersion {
            device.osVersion = osVersion
        }
        
        if let system = request.system {
            device.system = system.rawValue
        }
        
        if let token = request.pushToken {
            device.pushToken = token
        }
        
        try await req.repositories.devices.update(device)
        return try .init(from: device)
    }
}

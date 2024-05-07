import Common
import Entities
import Vapor

extension User.Detail.Response: Content {
    init(from model: UserAccountModel) throws {
        try self.init(
            id: model.requireID(),
            email: model.email,
            firstName: model.firstName,
            lastName: model.lastName,
            location: .init(from: model.location),
            avatar: model.avatar,
            followers: model.followers.map(User.List.Response.init(from:)),
            following: model.following.map(User.List.Response.init(from:)),
            isAdmin: model.isAdmin,
            isEmailVerified: model.isEmailVerified
        )
    }
}

extension User.List.Response: Content {
    init(from model: UserAccountModel) throws {
        self.init(
            id: try model.requireID(),
            firstName: model.firstName,
            lastName: model.lastName,
            avatar: model.avatar,
            email: model.email
        )
    }
}

extension User.Update.Response: Content {
    init(from model: UserAccountModel) throws {
        try self.init(
            id: model.requireID(),
            email: model.email,
            firstName: model.firstName,
            lastName: model.lastName,
            location: .init(from: model.location),
            isAdmin: model.isAdmin,
            isEmailVerified: model.isEmailVerified
        )
    }
}

extension Entities.Location {
    init?(from db: LocationModel?) {
        guard let db else { return nil }
        
        self.init(
            address: db.address,
            city: db.city,
            zipcode: db.zipcode,
            longitude: db.longitude,
            latitude: db.latitude,
            radius: db.radius
        )
    }
}

import Common
import Entities
import Vapor

extension User.Detail.Response: Content {
    init(from model: UserAccountModel) throws {
        self.init(
            id: try model.requireID(),
            email: model.email,
            fullName: model.fullName,
            isAdmin: model.isAdmin,
            isEmailVerified: model.isEmailVerified
        )
    }
}

extension User.List.Response: Content {
    init(from model: UserAccountModel) throws {
        self.init(
            id: try model.requireID(),
            fullName: model.fullName,
            email: model.email
        )
    }
}

extension User.Update.Response: Content {
    init(from model: UserAccountModel) throws {
        try self.init(
            id: model.requireID(),
            email: model.email,
            fullName: model.fullName,
            isAdmin: model.isAdmin,
            isEmailVerified: model.isEmailVerified
        )
    }
}

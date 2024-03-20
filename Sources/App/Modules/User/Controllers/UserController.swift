import Common
import Entities
import Fluent
import JWT
import Vapor

struct UserController {
    func getCurrentUser(_ req: Request) async throws -> User.Detail.Response {
        try .init(from: req.auth.require(UserAccountModel.self))
    }
    
    func delete(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(UserAccountModel.self)
        try await req.users.delete(id: user.requireID())
        return .ok
    }
    
    func list(_ req: Request) async throws -> [User.List.Response] {
        try await req.users.all().map { model in
            try User.List.Response(from: model)
        }
    }
    
    func patch(_ req: Request) async throws -> User.Update.Response {
        let request = try req.content.decode(User.Update.Request.self)
        let user = try req.auth.require(UserAccountModel.self)
        
        if let email = request.email {
            user.email = email
        }
        
        if let name = request.fullName {
            user.fullName = name
        }
        
        try await req.users.update(user)
        return try .init(from: user)
    }
}

import Entities
import Vapor

struct BusinessController {
    
    func create(_ req: Request) async throws -> Business.Create.Response {
        let request = try req.content.decode(Business.Create.Request.self)
        
        guard let user = try await req.repositories.users.find(id: request.userID) else {
            throw AuthenticationError.userNotFound
        }
        
        let model = try BusinessAccountModel(
            user: user,
            name: request.name,
            industry: request.industry,
            website: request.website,
            contactPhone: request.phone,
            contactEmail: request.email,
            description: request.description,
            photoIds: request.photoIds,
            isVerified: request.isVerified,
            avatarId: request.avatarId
        )
        
        try await req.repositories.businesses.create(model)
        
        let openingHoursModels = try OpeningHoursModel.create(
            business: model,
            from: request.openingTimes
        )
        
        try await req.repositories.businesses.create(openingHoursModels)
        
        return try .init(
            user: user,
            business: model
        )
    }
}

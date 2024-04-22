import Entities
import Foundation
import Vapor

extension OpeningHoursModel {
    static func create(
        business: BusinessAccountModel,
        from models: [Business.OpeningTime]
    ) throws -> [OpeningHoursModel] {
        try models.map { model in
            try OpeningHoursModel(db: business, request: model)
        }
    }
    
    convenience init(
        db: BusinessAccountModel,
        request: Business.OpeningTime
    ) throws {
        self.init(
            day: request.day.rawValue,
            openingTime: request.opening,
            closingTime: request.closing,
            businessID: try db.requireID()
        )
    }
}

extension LocationModel {
    convenience init(
        db: UserAccountModel,
        request: Location
    ) throws {
        self.init(
            address: request.address,
            city: request.city,
            zipcode: request.zipcode,
            longitude: request.longitude,
            latitude: request.latitude,
            radius: request.radius,
            userId: try db.requireID()
        )
    }
}

extension Business.Create.Response: Content {
    init(
        user: UserAccountModel,
        business: BusinessAccountModel
    ) throws {
        self.init(
            userID: try user.requireID(),
            id: try business.requireID(),
            email: user.email,
            isEmailVerified: user.isEmailVerified,
            name: business.name,
            openingTimes: try business.openingHours.map(Business.OpeningTime.init(from:)),
            industry: business.industry,
            website: business.website,
            phone: business.contactPhone,
            contactEmail: business.contactEmail,
            description: business.description,
            photoIds: business.photoIds,
            avatarId: business.avatarId,
            isBusinessVerified: business.isVerified
        )
    }
}

extension Business.OpeningTime {
    init(from model: OpeningHoursModel) throws {
        guard let day = Day(rawValue: model.day) else {
            throw Abort(.badRequest)
        }
        
        self.init(
            day: day,
            opening: model.openingTime,
            closing: model.closingTime
        )
    }
}

extension Location {
    init(from model: LocationModel) {
        self.init(
            address: model.address,
            city: model.city,
            zipcode: model.zipcode,
            longitude: model.longitude,
            latitude: model.latitude,
            radius: model.radius
        )
    }
}

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

        let locationModel = try LocationModel(
            db: model,
            request: request.location
        )
        
        try await req.repositories.businesses.create(openingHoursModels)
        try await req.repositories.businesses.add(locationModel, to: model)
        
        return try .init(
            user: user,
            business: model,
            location: locationModel
        )
    }
}

public enum Business {}

public extension Business {
    enum Create {
        public struct Request: Codable, Equatable {
            public let userID: UUID
            public let name: String
            public let openingTimes: [OpeningTime]
            public let location: Location
            public let industry: String
            public let website: String?
            public let phone: String
            public let email: String
            public let description: String
            public let photoIds: [UUID]
            public let avatarId: UUID
            public let isVerified: Bool
            
            public init(
                userID: UUID,
                name: String,
                openingTimes: [OpeningTime],
                location: Location,
                industry: String,
                website: String? = nil,
                phone: String,
                email: String,
                description: String,
                photoIds: [UUID],
                avatarId: UUID,
                isVerified: Bool
            ) {
                self.userID = userID
                self.name = name
                self.openingTimes = openingTimes
                self.location = location
                self.industry = industry
                self.website = website
                self.phone = phone
                self.email = email
                self.description = description
                self.photoIds = photoIds
                self.avatarId = avatarId
                self.isVerified = isVerified
            }
        }
        
        public struct Response: Codable, Equatable {
            public let userID: UUID
            public let id: UUID
            public let email: String
            public let isEmailVerified: Bool
            public let name: String
            public let openingTimes: [OpeningTime]
            public let location: Location
            public let industry: String
            public let website: String?
            public let phone: String
            public let contactEmail: String
            public let description: String
            public let photoIds: [UUID]
            public let avatarId: UUID
            public let isBusinessVerified: Bool

            public init(
                userID: UUID,
                id: UUID,
                email: String,
                isEmailVerified: Bool,
                name: String,
                openingTimes: [OpeningTime],
                location: Location,
                industry: String,
                website: String?,
                phone: String,
                contactEmail: String,
                description: String,
                photoIds: [UUID],
                avatarId: UUID,
                isBusinessVerified: Bool
            ) {
                self.userID = userID
                self.id = id
                self.email = email
                self.isEmailVerified = isEmailVerified
                self.name = name
                self.openingTimes = openingTimes
                self.location = location
                self.industry = industry
                self.website = website
                self.phone = phone
                self.contactEmail = contactEmail
                self.description = description
                self.photoIds = photoIds
                self.avatarId = avatarId
                self.isBusinessVerified = isBusinessVerified
            }
        }
    }
}

public extension Business {
    struct OpeningTime: Codable, Equatable {
        public enum Day: String, Codable, Equatable {
            case monday
            case tuesday
            case wednesday
            case thursday
            case friday
            case saturday
            case sunday
        }
        
        public let day: Day
        public let opening: String
        public let closing: String
        
        public init(
            day: Day,
            opening: String,
            closing: String
        ) {
            self.day = day
            self.opening = opening
            self.closing = closing
        }
    }
}

public extension Business {
    struct Location: Codable, Equatable {
        public let address: String
        public let city: String
        public let zipcode: String
        public let longitude: Double
        public let latitude: Double
        
        public init(
            address: String,
            city: String,
            zipcode: String,
            longitude: Double,
            latitude: Double
        ) {
            self.address = address
            self.city = city
            self.zipcode = zipcode
            self.longitude = longitude
            self.latitude = latitude
        }
    }
}

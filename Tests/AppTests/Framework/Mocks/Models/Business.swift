@testable import App
import Entities
import Vapor

extension BusinessAccountModel {
    static func mock(
        id: UUID? = .init(),
        user: UserAccountModel,
        name: String = "Business name",
        industry: String = "Industry",
        website: String? = "website.com",
        contactPhone: String = "001234",
        contactEmail: String = "business@example.com",
        description: String = "Business Description",
        photoIds: [UUID] = [],
        isVerified: Bool = true,
        avatarId: UUID = .init()
    ) -> BusinessAccountModel {
        try! self.init(
            id: id,
            user: user,
            name: name,
            industry: industry,
            website: website,
            contactPhone: contactPhone,
            contactEmail: contactEmail,
            description: description,
            photoIds: photoIds,
            isVerified: isVerified,
            avatarId: avatarId
        )
    }
}

extension Business.Create.Request {
    static func mock(
        userID: UUID,
        name: String = "Business Name",
        openingTimes: [Business.OpeningTime] = .mock(),
        industry: String = "Industry",
        website: String? = "website.com",
        phone: String = "001234",
        email: String = "business@example.com",
        description: String = "Business Description",
        photoIds: [UUID] = [],
        avatarId: UUID = .init(),
        isVerified: Bool = true
    ) -> Business.Create.Request {
        self.init(
            userID: userID,
            name: name,
            openingTimes: openingTimes,
            industry: industry,
            website: website,
            phone: phone,
            email: email,
            description: description,
            photoIds: photoIds,
            avatarId: avatarId,
            isVerified: isVerified
        )
    }
}

extension OpeningHoursModel {
    static func mock(
        id: UUID = .init(),
        business: BusinessAccountModel,
        day: String = "Monday",
        openingTime: String = "8:00",
        closingTime: String = "20:00"
    ) -> OpeningHoursModel {
        self.init(
            id: id,
            day: day,
            openingTime: openingTime,
            closingTime: closingTime,
            businessID: business.id!
        )
    }
}

extension Array where Element == Business.OpeningTime {
    static func mock() -> [Business.OpeningTime] {
        [
            .init(day: .monday, opening: "8:00", closing: "20:00")
        ]
    }
}

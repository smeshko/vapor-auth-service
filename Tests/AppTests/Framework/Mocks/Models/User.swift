@testable import App
import Entities
import Vapor

extension UserAccountModel {
    static func mock(
        app: Application,
        id: UUID = .init(),
        email: String = "test@test.com",
        firstName: String? = "John",
        lastName: String? = "Doe",
        isAdmin: Bool = false,
        isEmailVerified: Bool = true
    ) throws -> UserAccountModel {
        try UserAccountModel(
            id: id,
            email: email,
            password: app.password.hash("password"),
            firstName: firstName,
            lastName: lastName,
            isAdmin: isAdmin,
            isEmailVerified: isEmailVerified
        )
    }
}

extension Location {
    static func mock(
        address: String = "Business Road",
        city: String = "San Francisco",
        zipcode: String = "94016",
        longitude: Double = 37.7749,
        latitude: Double = 122.4194,
        radius: Double = 500
    ) -> Location {
        self.init(
            address: address,
            city: city,
            zipcode: zipcode,
            longitude: longitude,
            latitude: latitude,
            radius: radius
        )
    }
}

extension LocationModel {
    static func mock(
        id: UUID = .init(),
        address: String = "Address",
        city: String = "City",
        zipcode: String = "9000",
        longitude: Double = 10,
        latitude: Double = 15,
        radius: Double = 500,
        userId: UUID
    ) -> LocationModel {
        LocationModel(
            id: id,
            address: address,
            city: city,
            zipcode: zipcode,
            longitude: longitude,
            latitude: latitude,
            radius: radius,
            userId: userId
        )
    }
}

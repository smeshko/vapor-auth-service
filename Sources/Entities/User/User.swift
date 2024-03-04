import Foundation

public enum User {}

public extension User {
    enum Detail {
        public struct Response: Codable, Equatable {
            public let id: UUID
            public let email: String
            public let fullName: String
            public let isAdmin: Bool
            public let isEmailVerified: Bool

            public init(
                id: UUID,
                email: String,
                fullName: String,
                isAdmin: Bool,
                isEmailVerified: Bool
            ) {
                self.id = id
                self.email = email
                self.fullName = fullName
                self.isAdmin = isAdmin
                self.isEmailVerified = isEmailVerified
            }
        }
    }
    
    enum Update {
        public struct Request: Codable, Equatable {
            public let email: String?
            public let fullName: String?

            public init(
                email: String?,
                fullName: String?
            ) {
                self.email = email
                self.fullName = fullName
            }
        }
        
        public struct Response: Codable, Equatable {
            public let id: UUID
            public let email: String
            public let fullName: String
            public let isAdmin: Bool
            public let isEmailVerified: Bool

            public init(
                id: UUID,
                email: String,
                fullName: String,
                isAdmin: Bool,
                isEmailVerified: Bool
            ) {
                self.id = id
                self.email = email
                self.fullName = fullName
                self.isAdmin = isAdmin
                self.isEmailVerified = isEmailVerified
            }
        }
    }
    
    enum List {
        public struct Response: Codable, Equatable {
            public let id: UUID
            public let fullName: String
            public let email: String

            public init(
                id: UUID,
                fullName: String,
                email: String
            ) {
                self.id = id
                self.fullName = fullName
                self.email = email
            }
        }
    }
}

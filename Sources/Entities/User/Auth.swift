import Foundation

public enum Auth {}

public extension Auth {
    enum Login {
        public struct Request: Codable, Equatable {
            public let email: String
            public let password: String
            
            public init(
                email: String,
                password: String
            ) {
                self.email = email
                self.password = password
            }
        }
        
        public struct Response: Codable, Equatable {
            public let token: TokenRefresh.Response
            public let user: User.Detail.Response
            
            public init(
                token: TokenRefresh.Response,
                user: User.Detail.Response
            ) {
                self.token = token
                self.user = user
            }
        }
    }
    
    enum SignUp {
        public struct Request: Codable, Equatable {
            public let email: String
            public let password: String
            public let fullName: String
            
            public init(
                email: String,
                password: String,
                fullName: String
            ) {
                self.email = email
                self.password = password
                self.fullName = fullName
            }
        }
        
        public struct Response: Codable, Equatable {
            public let token: TokenRefresh.Response
            public let user: User.Detail.Response

            public init(
                token: TokenRefresh.Response,
                user: User.Detail.Response
            ) {
                self.token = token
                self.user = user
            }
        }
    }
    
    enum PasswordReset {
        public struct Request: Codable, Equatable {
            public let email: String
            
            public init(email: String) {
                self.email = email
            }
        }
    }
    
    enum TokenRefresh {
        public struct Request: Codable, Equatable {
            public let refreshToken: String
            
            public init(refreshToken: String) {
                self.refreshToken = refreshToken
            }
        }
        
        public struct Response: Codable, Equatable {
            public let refreshToken: String
            public let accessToken: String
            
            public init(
                refreshToken: String,
                accessToken: String
            ) {
                self.refreshToken = refreshToken
                self.accessToken = accessToken
            }
        }
    }
}

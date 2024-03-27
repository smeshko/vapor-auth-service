import Common
import Vapor

extension Request {
    var users: any UserRepository { application.repositories.users.for(self) }
    var refreshTokens: any RefreshTokenRepository { application.repositories.refreshTokens.for(self) }
    var emailTokens: any EmailTokenRepository { application.repositories.emailTokens.for(self) }
    var passwordTokens: any PasswordTokenRepository { application.repositories.passwordTokens.for(self) }
    var posts: any PostRepository { application.repositories.posts.for(self) }
    var media: any MediaRepository { application.repositories.media.for(self) }
}

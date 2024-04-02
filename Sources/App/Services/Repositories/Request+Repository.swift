import Common
import Vapor

extension Request {
    var repositories: Application.Repositories {
        application.repositories
    }
}

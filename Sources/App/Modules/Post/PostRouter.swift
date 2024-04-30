import Entities
import Vapor

struct PostRouter: RouteCollection {
    let controller = PostController()
    
    func boot(routes: any RoutesBuilder) throws {
        let postsAPI = routes
            .grouped("api")
            .grouped("posts")
        
        postsAPI
            .get(":postID", use: controller.details)
        
        postsAPI
            .get("all", use: controller.all)
        postsAPI
            .get("all", ":userID", use: controller.userPosts)

        let protectedPostsAPI = postsAPI
            .grouped(UserAccountModel.guard())

        protectedPostsAPI
            .post("create", use: controller.create)

        protectedPostsAPI
            .post("like", ":postID", use: controller.like)
    }
}

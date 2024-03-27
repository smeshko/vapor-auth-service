import Vapor

struct PostRouter: RouteCollection {
    let controller = PostController()
    
    func boot(routes: any RoutesBuilder) throws {
        let postsAPI = routes
            .grouped("api")
            .grouped("posts")
        
        postsAPI.get("all", use: controller.all)
        postsAPI
            .get("all", ":userID", use: controller.userPosts)

        let protectedPostsAPI = postsAPI
            .grouped(UserPayloadAuthenticator())

        protectedPostsAPI.post("create", use: controller.create)
    }
}

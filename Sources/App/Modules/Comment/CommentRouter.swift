import Vapor
import Entities

struct CommentRouter: RouteCollection {
    let controller = CommentController()
    
    func boot(routes: any RoutesBuilder) throws {
        let commentsAPI = routes
            .grouped("api")
            .grouped("comments")
        
        commentsAPI
            .get("all", ":postID", use: controller.allForPost)

        let guardedAPI = commentsAPI
            .grouped(UserAccountModel.guard())

        guardedAPI
            .post("post", ":postID", use: controller.post)
        
        guardedAPI
            .post("reply", ":commentID", use: controller.reply)
    }
}

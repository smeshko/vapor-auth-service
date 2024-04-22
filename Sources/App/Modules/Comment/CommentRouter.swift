import Vapor
import Entities

struct CommentRouter: RouteCollection {
    let controller = CommentController()
    
    func boot(routes: any RoutesBuilder) throws {
        let commentsAPI = routes
            .grouped("api")
            .grouped("comments")
            .grouped(UserAccountModel.guard())
        
        commentsAPI
            .post("post", ":postID", use: controller.post)
        
        commentsAPI
            .post("reply", ":commentID", use: controller.reply)
    }
}

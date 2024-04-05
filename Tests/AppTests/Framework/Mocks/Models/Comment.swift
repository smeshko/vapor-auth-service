@testable import App
import Vapor

extension CommentModel {
    static func mock(
        id: UUID? = .init(),
        parentCommentID: UUID? = nil,
        userId: UUID,
        postId: UUID,
        text: String = "This is a reply"
    
    ) -> CommentModel {
        .init(
            id: id,
            parentCommentID: parentCommentID,
            userId: userId,
            postId: postId,
            text: text
        )
    }
}

@testable import App
import Vapor

extension PostModel {
    static func mock(
        id: UUID? = .init(),
        user: UserAccountModel,
        imageIDs: [UUID]? = nil,
        videoIDs: [UUID]? = nil,
        createdAt: Date? = .now,
        text: String = "This is a post",
        title: String = "This is title",
        category: String = "Category",
        tags: [String] = []
    ) throws -> PostModel {
        try .init(
            id: id,
            user: user,
            imageIDs: imageIDs,
            videoIDs: videoIDs,
            createdAt: createdAt,
            category: category,
            text: text,
            title: title,
            tags: tags
        )
    }
}

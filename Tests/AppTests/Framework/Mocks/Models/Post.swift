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
        tags: [String] = []
    ) throws -> PostModel {
        try .init(
            id: id,
            user: user,
            imageIDs: imageIDs,
            videoIDs: videoIDs,
            createdAt: createdAt,
            text: text,
            tags: tags
        )
    }
}

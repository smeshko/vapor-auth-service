import Common
import Entities
import Vapor

extension ContentError: @retroactive DebuggableError {}
extension ContentError: @retroactive CustomStringConvertible {}
extension ContentError: @retroactive CustomDebugStringConvertible {}
extension ContentError: @retroactive LocalizedError {}
extension ContentError: @retroactive AppError {}

extension ContentError: @retroactive AbortError {
    public var status: HTTPResponseStatus {
        .notFound
    }
}

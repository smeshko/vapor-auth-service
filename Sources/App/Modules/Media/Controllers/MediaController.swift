import Common
import Entities
import Fluent
import Vapor

struct MediaController {
    func upload(_ req: Request) async throws -> Media.Upload.Response {
        let input = try req.content.decode(Media.Upload.Request.self)
        
        let buffer = ByteBuffer(data: input.data)
        let id = UUID()
        
        let model = MediaModel(
            id: id,
            type: input.type.rawValue,
            ext: input.ext,
            key: "\(id).\(input.ext)"
        )
        
        try await req.repositories.media.create(model)
        try await req.services.fileStorage.save(buffer, key: model.key)

        return .init(id: id, type: input.type)
    }
    
    func download(_ req: Request) async throws -> Media.Download.Response {
        let mediaId = try req.parameters.require("mediaID", as: UUID.self)

        guard let model = try await req.repositories.media.find(id: mediaId) else {
            throw ContentError.contentNotFound
        }
        
        let key = "\(try model.requireID()).\(model.ext)"
        let data = try await req.services.fileStorage.fetch(key)
        
        return Media.Download.Response(data: data)
    }
}

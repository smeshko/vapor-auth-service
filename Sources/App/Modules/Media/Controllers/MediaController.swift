import Common
import Entities
import Fluent
import Vapor

struct MediaController {
    func upload(_ req: Request) async throws -> Media.Upload.Response {
        let input = try req.content.decode(Media.Upload.Request.self)
        
        guard input.data.count < Constants.photoMaxSize else {
            throw ContentError.mediaTooLarge
        }
        
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
        let request = try req.content.decode(Media.Download.Request.self)

        guard let model = try await req.repositories.media.find(id: request.id) else {
            throw ContentError.mediaToDownloadNotFound
        }
        
        let key = "\(try model.requireID()).\(model.ext)"
        let data = try await req.services.fileStorage.fetch(key, percentageOfOriginalSize: request.size.percentage)
        
        return Media.Download.Response(data: data)
    }
    
    enum Constants {
        static let photoMaxSize = 5000000
    }
}

extension Media.Size {
    var percentage: Double? {
        switch self {
        case .s: 0.25
        case .m: 0.5
        case .o: nil
        }
    }
}

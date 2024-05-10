import Common
import Entities
import Fluent
import Vapor

/// A struct representing a controller for handling media upload and download operations
struct MediaController {
    /// Handles the asynchronous upload of media files.
    ///
    /// - Parameters:
    ///   - req: The incoming request.
    /// - Throws: An error of type `ContentError` if the media file is too large or if there are issues with the upload process.
    /// - Returns: A `Media.Upload.Response` object.
    func upload(_ req: Request) async throws -> Media.Upload.Response {
        // Decode the incoming request data to Media.Upload.Request object
        let input = try req.content.decode(Media.Upload.Request.self)
        
        // Check if the uploaded data exceeds the maximum photo size
        guard input.data.count < Constants.photoMaxSize else {
            throw ContentError.mediaTooLarge
        }
        
        // Create a ByteBuffer from the upload data and generate a unique ID
        let buffer = ByteBuffer(data: input.data)
        let id = UUID()
        
        // Create a MediaModel object based on the upload request
        let model = MediaModel(
            id: id,
            type: input.type.rawValue,
            ext: input.ext,
            key: "\(id).\(input.ext)"
        )
        
        // Save the media model and upload the file to file storage asynchronously
        try await req.repositories.media.create(model)
        try await req.services.fileStorage.save(buffer, key: model.key)

        // Return the uploaded media information
        return .init(id: id, type: input.type)
    }
    
    /// Handles the asynchronous download of media files.
    ///
    /// - Parameters:
    ///   - req: The incoming request.
    /// - Throws: An error of type `ContentError` if the requested media file is not found or if there are issues with the download process.
    /// - Returns: A `Media.Download.Response` object containing the downloaded data.
    func download(_ req: Request) async throws -> Media.Download.Response {
        // Decode the incoming request data to Media.Download.Request object
        let request = try req.content.decode(Media.Download.Request.self)

        // Find the requested media file from the repository
        guard let model = try await req.repositories.media.find(id: request.id) else {
            throw ContentError.mediaToDownloadNotFound
        }
        
        // Generate the key based on the media model and fetch the file from storage asynchronously
        let key = "\(try model.requireID()).\(model.ext)"
        let data = try await req.services.fileStorage.fetch(key, percentageOfOriginalSize: request.size.percentage)
        
        // Return the downloaded media data
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

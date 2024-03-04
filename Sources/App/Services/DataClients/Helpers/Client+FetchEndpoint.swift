import Common
import Vapor

extension Client {
    func fetchResults<T: Codable>(
        at endpoint: Endpoint,
        for app: Application
    ) async throws -> T {
        guard let url = endpoint.url else { throw Abort(.notFound) }
    
        let response = try await get(
            URI(url: url),
            headers: HTTPHeaders(endpoint.headers.map { ($0.key, $0.value) })
        ) { request in
            try request.query.encode(endpoint.queryParameters ?? [:])
            app.logger.info("Starting request: \(request)")
        }
        
        app.logger.info("Received response: \(response)")
        
        do {
            return try response.content.decode(T.self, using: JSONDecoder())
        } catch _ as DecodingError {
            throw Abort(.badRequest)
        }
    }
}


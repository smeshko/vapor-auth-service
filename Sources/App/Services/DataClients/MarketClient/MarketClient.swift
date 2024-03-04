import Foundation
import Common
import Vapor

public struct MarketClient {
    public enum MarketStatus {
        case open, notOpenYet, closedForTheDay
    }
    
    public var marketStatus: () async throws -> MarketStatus
}

public extension MarketClient {
    static func live(_ app: Application) -> MarketClient {
        .init {
            let marketData: MarketStatusResponse = try await app.client.fetchResults(at: PolygonioEndpoint.marketStatus, for: app)

            if marketData.market == .open {
                return .open
            }
            
            if marketData.market == .extended && marketData.earlyHours {
                return .notOpenYet
            }
            
            if marketData.market == .extended && marketData.afterHours {
                return .closedForTheDay
            }
            
            return .closedForTheDay
        }
    }
}

extension Application.DataClients {
    var market: MarketClient {
        guard let storage = storage.makeMarketClient else {
            fatalError("MarketClient not configured, use: app.marketClient.use()")
        }
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> MarketClient) {
        storage.makeMarketClient = make
    }
}

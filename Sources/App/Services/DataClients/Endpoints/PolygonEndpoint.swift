import Common
import Vapor

enum PolygonioEndpoint: Endpoint {
    case marketStatus

    case aggregates(
        _ apiKey: String,
        _ ticker: String,
        _ multiplier: Int,
        _ timespan: String,
        _ start: String,
        _ end: String
    )

    case news(_ apiKey: String, _ ticker: String, _ limit: Int)
    case details(_ apiKey: String, _ ticker: String)
    case financials(_ apiKey: String, _ ticker: String)
    case dividends(_ apiKey: String, _ ticker: String)
    case quote(_ apiKey: String, _ ticker: String)
    case latestQuote(_ apiKey: String, _ ticker: String)
    
    var apiKey: String {
        Environment.get("POLYGON_API_KEY") ?? ""
    }
    
    var path: String {
        switch self {
        case let .aggregates(_, ticker, multiplier, timespan, start, end):
            return "/v2/aggs/ticker/\(ticker)/range/\(multiplier)/\(timespan)/\(start)/\(end)"
        case .news:
            return "/v2/reference/news"
        case .details(_, let ticker):
            return "/v3/reference/tickers/\(ticker)"
        case .financials:
            return "vX/reference/financials"
        case .dividends:
            return "/v3/reference/dividends"
        case .quote(_, let ticker):
            return "/v3/quotes/\(ticker)"
        case .marketStatus:
            return "/v1/marketstatus/now"
        case .latestQuote(_, let ticker):
            return "/v2/last/nbbo/\(ticker)"
        }
    }
    
    var url: URL? {
        URLBuilder(endpoint: self)
            .components()
            .build()
    }
    
    var method: Common.HTTPMethod { .get }
    
    var host: String { "api.polygon.io" }
    
    var queryParameters: [String : String]? {
        switch self {
        case let .details(apiKey, _), let .financials(apiKey, _), 
            let .quote(apiKey, _), let .latestQuote(apiKey, _):
            return ["apiKey": apiKey]
        case .marketStatus:
            return ["apiKey": apiKey]
        case let .aggregates(apiKey, _, _, _, _, _):
            return [
                "apiKey": apiKey,
                "limit": "50000"
            ]
        case let .news(apiKey, ticker, limit):
            return [
                "apiKey": apiKey,
                "ticker": ticker,
                "order": "desc",
                "sort": "published_utc",
                "limit": "\(limit)",
            ]
        case let .dividends(apiKey, ticker):
            return [
                "apiKey": apiKey,
                "ticker": ticker
            ]
        }
    }

    var postfix: String? { nil }
    var body: Data? { nil }
    var headers: [String : String] { [:] }
}

import Vapor

struct MarketStatusResponse: Content {
    enum Status: String, Content {
        case extended = "extended-hours"
        case open = "open"
        case closed = "closed"
    }
    
    let afterHours: Bool
    let earlyHours: Bool
    let exchanges: [String: Status]
    let market: Status
    let serverTime: String
}

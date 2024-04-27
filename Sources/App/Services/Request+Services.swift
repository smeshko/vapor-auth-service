import Vapor

extension Request {
    public struct Services {
        let request: Request
        init(request: Request) {
            self.request = request
        }
    }
    
    public var services: Services {
        Services(request: self)
    }
}

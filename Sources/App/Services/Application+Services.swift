import Vapor

extension Application {
    struct Services {
        let application: Application
    }
    
    var services: Services {
        .init(application: self)
    }
}

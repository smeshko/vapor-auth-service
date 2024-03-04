import Vapor

extension Application {
    struct DataClients {
        struct Provider {
            static var database: Self {
                .init {
                    $0.dataClients.use { MarketClient.live($0) }
                }
            }
            
            let run: (Application) -> ()
        }
        
        final class Storage {
            var makeMarketClient: ((Application) -> MarketClient)?
            init() { }
        }
        
        struct Key: StorageKey {
            typealias Value = Storage
        }
        
        let app: Application
        
        func use(_ provider: Provider) {
            provider.run(app)
        }
        
        var storage: Storage {
            if app.storage[Key.self] == nil {
                app.storage[Key.self] = .init()
            }
            return app.storage[Key.self]!
        }
    }
    
    var dataClients: DataClients {
        .init(app: self)
    }
}

extension Request {
    struct Clients {
        let http: Client
        let market: MarketClient
    }
    
    var clients: Clients {
        .init(
            http: application.client,
            market: application.dataClients.market
        )
    }
}

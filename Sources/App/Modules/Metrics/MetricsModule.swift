import Vapor
import Metrics
import Prometheus

struct MetricsModule: ModuleInterface {
    
    let router = MetricsRouter()
    
    func boot(_ app: Application) throws {
        try router.boot(routes: app.routes)
    }
    
    func setUp(_ app: Application) throws {
        let client = PrometheusMetricsFactory(client: PrometheusClient())
        MetricsSystem.bootstrap(client)
    }
}

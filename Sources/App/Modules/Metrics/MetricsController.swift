import Vapor
import Metrics
import Prometheus

struct MetricsController {
    func metrics(_ req: Request) async throws -> String {
        try await MetricsSystem.prometheus().collect()
    }
}

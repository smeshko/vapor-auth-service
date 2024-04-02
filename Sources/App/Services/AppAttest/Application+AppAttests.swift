import Foundation
import Vapor

public protocol AttestationService {
    func verify(
        attestation: Data,
        challenge: Data,
        keyID: Data,
        teamID: String,
        bundleID: String
    ) throws
}

extension Application {
    public struct AppAttests {
        public struct Provider {
            let run: ((Application) -> Void)
        }
        
        public let app: Application
        
        
        public func use(_ provider: Provider) {
            provider.run(app)
        }
        
        public func use(_ makeAppAttest: @escaping ((Application) -> AttestationService)) {
            storage.makeAppAttest = makeAppAttest
        }
        
        final class Storage {
            var makeAppAttest: ((Application) -> AttestationService)?
            init() {}
        }
        
        private struct Key: StorageKey {
            typealias Value = Storage
        }
        
        var storage: Storage {
            if let existing = self.app.storage[Key.self] {
                return existing
            } else {
                let new = Storage()
                self.app.storage[Key.self] = new
                return new
            }
        }
    }
    
    public var appAttests: AppAttests {
        .init(app: self)
    }
}

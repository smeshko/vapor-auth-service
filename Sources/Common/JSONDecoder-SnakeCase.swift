import Foundation

public extension JSONDecoder {
    func keyStrategy(_ strategy: JSONDecoder.KeyDecodingStrategy) -> JSONDecoder {
        keyDecodingStrategy = strategy
        return self
    }
    
    func dateStrategy(_ strategy: JSONDecoder.DateDecodingStrategy) -> JSONDecoder {
        dateDecodingStrategy = strategy
        return self
    }
    
    func dataStrategy(_ strategy: JSONDecoder.DataDecodingStrategy) -> JSONDecoder {
        dataDecodingStrategy = strategy
        return self
    }
}

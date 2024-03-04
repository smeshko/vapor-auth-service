import Foundation

/// Creates a task group that iterates over a collection of elements and runs an async task on each one.
///
/// For example if you want to fetch news for each ticker in an array and then map the result to a model,
/// you would use this function as follows:
///  ```
///  await runTaskGroup(
///     for: StockData.self,
///     elements: trending,
///     task: service.getTickerNews(_:),
///     onFinished: { TickerNewsModel(data: $0) }
///  )
///  ```
/// This function maps errors to a `nil` value and therefore ignores them in the end result
///
/// - Parameters:
///   - type: the return type of the async function to be called on each element
///   - elements: the collection of elements to iterate over
///   - task: the async function that is called for each element
///   - onFinished: any additional transformation to be done on each result of the function
/// - Returns: the result of the async functions mapped to the initial array of elements
public func runTaskGroup<V: Sendable, E>(
    for type: V.Type,
    elements: [E],
    task: @escaping (E) async throws -> V,
    onFinished: ((inout V) -> Void)? = nil
) async -> [V] {
    var result: [V] = []
    
    await withTaskGroup(of: Optional<V>.self) { group in
        for symbol in elements {
            group.addTask {
                do {
                    return try await task(symbol)
                } catch { return nil }
            }
            
            for await element in group.compactMap({$0}) {
                var copy = element
                onFinished?(&copy)
                result.append(copy)
            }
        }
    }
    
    return result
}

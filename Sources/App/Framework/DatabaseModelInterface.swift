import Vapor
import Fluent

/// Represents a Fluent database object.
///
/// Every database object should conform to this protocol to ensure naming consistency.
/// The protocol provides naming helpers for the database tabe and entries. 
public protocol DatabaseModelInterface: Fluent.Model
    where Self.IDValue == UUID
{    
    associatedtype Module: ModuleInterface

    static var schema: String { get }
}

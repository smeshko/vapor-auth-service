import Common
import Fluent
import Vapor

enum MediaMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(MediaModel.schema)
                .id()
                .field(MediaModel.FieldKeys.v1.key, .string)
                .field(MediaModel.FieldKeys.v1.ext, .string, .required)
                .field(MediaModel.FieldKeys.v1.type, .string, .required)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(MediaModel.schema).delete()
        }
    }
}

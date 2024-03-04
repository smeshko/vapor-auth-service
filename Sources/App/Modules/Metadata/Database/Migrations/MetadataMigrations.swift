import Vapor
import Fluent

enum MetadataMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(ChallengeTokenModel.schema)
                .id()
                .field(ChallengeTokenModel.FieldKeys.v1.value, .string, .required)
                .unique(on: ChallengeTokenModel.FieldKeys.v1.value)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(ChallengeTokenModel.schema).delete()
        }
    }
}

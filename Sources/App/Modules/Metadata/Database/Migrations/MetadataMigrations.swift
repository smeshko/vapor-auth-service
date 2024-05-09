import Vapor
import Fluent

enum MetadataMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(ChallengeTokenModel.schema)
                .id()
                .field(ChallengeTokenModel.FieldKeys.v1.value, .string, .required)
                .field(ChallengeTokenModel.FieldKeys.v1.createdAt, .datetime)
                .field(ChallengeTokenModel.FieldKeys.v1.updatedAt, .datetime)
                .field(ChallengeTokenModel.FieldKeys.v1.deletedAt, .datetime)
                .unique(on: ChallengeTokenModel.FieldKeys.v1.value)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(ChallengeTokenModel.schema).delete()
        }
    }
}

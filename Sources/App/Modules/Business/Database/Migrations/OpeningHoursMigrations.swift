import Common
import Fluent
import Vapor

enum OpeningHoursMigrations {
    struct v1: AsyncMigration {
        func prepare(on db: Database) async throws {
            try await db.schema(OpeningHoursModel.schema)
                .id()
                .field(OpeningHoursModel.FieldKeys.v1.day, .string, .required)
                .field(OpeningHoursModel.FieldKeys.v1.openingTime, .string, .required)
                .field(OpeningHoursModel.FieldKeys.v1.closingTime, .string, .required)
                .field(OpeningHoursModel.FieldKeys.v1.businessId, .uuid, .required)
                .foreignKey(
                    OpeningHoursModel.FieldKeys.v1.businessId,
                    references: BusinessAccountModel.schema, .id
                )
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(OpeningHoursModel.schema).delete()
        }
    }
}

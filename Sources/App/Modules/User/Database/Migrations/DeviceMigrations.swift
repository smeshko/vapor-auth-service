import Common
import Fluent
import Vapor

enum DeviceMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(DeviceModel.schema)
                .id()
                .field(DeviceModel.FieldKeys.v1.system, .string, .required)
                .field(DeviceModel.FieldKeys.v1.osVersion, .string, .required)
                .field(DeviceModel.FieldKeys.v1.pushToken, .string)
                .field(DeviceModel.FieldKeys.v1.createdAt, .datetime)
                .field(DeviceModel.FieldKeys.v1.updatedAt, .datetime)
                .field(DeviceModel.FieldKeys.v1.deletedAt, .datetime)
                .field(DeviceModel.FieldKeys.v1.userId, .uuid, .required)
                .foreignKey(
                    DeviceModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id,
                    onDelete: .cascade
                )
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(DeviceModel.schema).delete()
        }
    }
}

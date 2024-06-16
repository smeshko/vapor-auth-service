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
                .field(MediaModel.FieldKeys.v1.createdAt, .datetime)
                .field(MediaModel.FieldKeys.v1.updatedAt, .datetime)
                .field(MediaModel.FieldKeys.v1.deletedAt, .datetime)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(MediaModel.schema).delete()
        }
    }
    
    struct seed: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await MediaModel(
                id: UUID(uuidString: "7E132A2B-CDA6-47F5-88C3-A42C1B719B2E"),
                type: "photo",
                ext: "jpg",
                key: "7E132A2B-CDA6-47F5-88C3-A42C1B719B2E"
            ).create(on: database)
            
            try await MediaModel(
                id: UUID(uuidString: "871947E2-2A0E-498F-BED9-D3E1060D0A32"),
                type: "photo",
                ext: "jpg",
                key: "871947E2-2A0E-498F-BED9-D3E1060D0A32"
            ).create(on: database) // avatar
            
            try await MediaModel(
                id: UUID(uuidString: "C8C0FE53-6F22-42FD-8BE0-259FE4588B3D"),
                type: "photo",
                ext: "jpg",
                key: "C8C0FE53-6F22-42FD-8BE0-259FE4588B3D"
            ).create(on: database)
            
            try await MediaModel(
                id: UUID(uuidString: "E6A5E465-38DD-4E88-AF86-9788E021F3B6"),
                type: "photo",
                ext: "jpeg",
                key: "E6A5E465-38DD-4E88-AF86-9788E021F3B6"
            ).create(on: database)
            
            try await MediaModel(
                id: UUID(uuidString: "EE3D78AA-F2AE-4452-9709-B6B93E6EDC51"),
                type: "photo",
                ext: "jpg",
                key: "EE3D78AA-F2AE-4452-9709-B6B93E6EDC51"
            ).create(on: database)
            
            try await MediaModel(
                id: UUID(uuidString: "A78FD913-8B9A-421C-AAC7-1272956DA875"),
                type: "photo",
                ext: "jpg",
                key: "A78FD913-8B9A-421C-AAC7-1272956DA875"
            ).create(on: database) // avocado
        }
        
        func revert(on database: any Database) async throws {
            try await UserAccountModel.query(on: database).delete()
        }
    }
}

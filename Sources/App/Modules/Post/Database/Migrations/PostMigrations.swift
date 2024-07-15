import Common
import Fluent
import Vapor

enum PostMigrations {
    struct v1: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(PostModel.schema)
                .id()
                .field(PostModel.FieldKeys.v1.imageIDs, .array(of: .uuid))
                .field(PostModel.FieldKeys.v1.videoIDs, .array(of: .uuid))
                .field(PostModel.FieldKeys.v1.tags, .array(of: .string), .required)
                .field(PostModel.FieldKeys.v1.category, .string, .required)
                .field(PostModel.FieldKeys.v1.text, .string, .required)
                .field(PostModel.FieldKeys.v1.title, .string, .required)
                .field(PostModel.FieldKeys.v1.createdAt, .datetime)
                .field(PostModel.FieldKeys.v1.updatedAt, .datetime)
                .field(PostModel.FieldKeys.v1.deletedAt, .datetime)
                .field(PostModel.FieldKeys.v1.productIds, .array(of: .uuid))
                .field(PostModel.FieldKeys.v1.userId, .uuid, .required)
                .foreignKey(
                    PostModel.FieldKeys.v1.userId,
                    references: UserAccountModel.schema, .id,
                    onDelete: .cascade
                )
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(PostModel.schema).delete()
        }
    }
    
    struct seed: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await PostModel(
                user: UserAccountModel.query(on: database).first()!,
                imageIDs: [
                    UUID(uuidString: "7E132A2B-CDA6-47F5-88C3-A42C1B719B2E")!,
                    UUID(uuidString: "C8C0FE53-6F22-42FD-8BE0-259FE4588B3D")!,
                    UUID(uuidString: "E6A5E465-38DD-4E88-AF86-9788E021F3B6")!
                ],
                relatedProductIds: nil,
                category: "home_kitchen",
                text: "This is post",
                title: "This is a post with multiple images",
                tags: ["under_25"]
            ).create(on: database)
            
            try await PostModel(
                user: UserAccountModel.query(on: database).first()!,
                imageIDs: [
                    UUID(uuidString: "C8C0FE53-6F22-42FD-8BE0-259FE4588B3D")!
                ],
                relatedProductIds: nil,
                category: "grocery",
                text: "Aliqua commodo qui lorem dolor fugiat pariatur officia proident proident eu nostrud. Irure minim occaecat commodo laborum ad anim ex ullamco dolor proident ipsum dolore tempor voluptate ut. Reprehenderit eiusmod excepteur officia ullamco irure id eiusmod laboris eiusmod. Culpa consectetur ut nisi est consequat veniam ullamco amet aliquip exercitation proident dolor adipiscing veniam anim et. Consequat commodo esse laboris commodo sit velit consequat ut id voluptate irure. Tempor voluptate aliquip proident ex reprehenderit commodo pariatur laborum esse exercitation laborum. Incididunt est veniam fugiat dolor tempor sint minim velit est ut elit in sed anim anim quis exercitation. Ut elit qui do aute consequat do culpa sunt qui cupidatat. Dolore ex est sit id qui ad magna labore laboris sunt. Sint elit consectetur eiusmod tempor ut non duis commodo amet irure exercitation dolore qui consequat anim velit.",
                title: "This is a post with a long description",
                tags: ["under_25", "local_services"]
            ).create(on: database)

            try await PostModel(
                user: UserAccountModel.query(on: database).first()!,
                imageIDs: [
                    UUID(uuidString: "E6A5E465-38DD-4E88-AF86-9788E021F3B6")!
                ],
                relatedProductIds: nil,
                category: "organic_food",
                text: "This is post",
                title: "This is a post with with a long title that should get truncated on Discover",
                tags: ["under_25"]
            ).create(on: database)
        }
        
        func revert(on database: any Database) async throws {
            try await PostModel.query(on: database).delete()
        }
    }
}

import Vapor
import SotoS3

struct S3FileStorage: FileStorageProvider {
    let app: Application
    
    private let awsClient: AWSClient
    private let s3: S3
    
    init(app: Application) {
        self.app = app
        
        awsClient = AWSClient(
            credentialProvider: .static(
                accessKeyId: Environment.awsAccessKey,
                secretAccessKey: Environment.awsSecretAccessKey
            ),
            httpClientProvider: .createNew
        )
        
        s3 = S3(client: awsClient, region: .uswest1)
    }
    
    func save(_ file: ByteBuffer, key: String) async throws {
        defer {
            try? awsClient.syncShutdown()
        }
        
        let putObjectRequest = S3.PutObjectRequest(
            body: .byteBuffer(file),
            bucket: Environment.awsS3BucketName,
            key: key
        )

        let _ = try await s3.putObject(putObjectRequest)
    }
    
    func fetch(_ fileKey: String) async throws -> Data {
        defer {
            try? awsClient.syncShutdown()
        }

        let getRequest = S3.GetObjectRequest(
            bucket: Environment.awsS3BucketName,
            key: fileKey
        )
        
        let getResponse = try await s3.getObject(getRequest)
        
        guard let data = getResponse.body?.asData(), !data.isEmpty else {
            throw Abort(.badRequest)
        }
        
        return data
    }
}

extension Application.FileStorage.Provider {
    static var s3: Self {
        .init {
            $0.fileStorage.use(S3FileStorage.init(app:))
        }
    }
}

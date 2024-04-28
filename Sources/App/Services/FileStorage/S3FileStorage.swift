import Vapor
import Entities
import SotoS3

extension Application.Service.Provider where ServiceType == FileStorageService {
    static var s3: Self {
        .init {
            $0.services.fileStorage.use { S3FileStorage(app: $0) }
        }
    }
}

class S3FileStorage: FileStorageService {
    let app: Application
    
    private let awsClient: AWSClient
    private let s3: S3
    
    required init(app: Application) {
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
    
    deinit {
        try? awsClient.syncShutdown()
    }
    
    func `for`(_ request: Request) -> any FileStorageService {
        Self.init(app: request.application)
    }
    
    func save(_ file: ByteBuffer, key: String) async throws {
        let putObjectRequest = S3.PutObjectRequest(
            body: .byteBuffer(file),
            bucket: Environment.awsS3BucketName,
            key: key
        )

        let _ = try await s3.putObject(putObjectRequest)
    }
    
    func fetch(_ fileKey: String) async throws -> Data {
        let getRequest = S3.GetObjectRequest(
            bucket: Environment.awsS3BucketName,
            key: fileKey
        )
        
        let getResponse = try await s3.getObject(getRequest)
        
        guard let data = getResponse.body?.asData(), !data.isEmpty else {
            throw ContentError.cannotFetchMedia
        }
        return data
    }
}

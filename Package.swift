// swift-tools-version:5.9
import PackageDescription

let fluent = Target.Dependency.product(name: "Fluent", package: "fluent")
let vapor = Target.Dependency.product(name: "Vapor", package: "vapor")
let prometheus = Target.Dependency.product(name: "SwiftPrometheus", package: "SwiftPrometheus")
let entities = Target.Dependency.product(name: "Entities", package: "id5-entities")
let common = Target.Dependency.product(name: "Common", package: "id5-common")
let s3 = Target.Dependency.product(name: "SotoS3", package: "soto")
let attest = Target.Dependency.product(name: "AppAttest", package: "app-attest")
let apns = Target.Dependency.product(name: "VaporAPNS", package: "apns")

let package = Package(
    name: "id5-auth-service",
    platforms: [
        .macOS(.v14)
    ],
    products: [
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.83.1"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/MrLotU/SwiftPrometheus.git", from: "1.0.2"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/swift-html", from: "1.7.0"),
        .package(url: "https://github.com/soto-project/soto.git", from: "6.0.0"),
        .package(url: "https://github.com/vapor/apns.git", from: "4.0.0"),
        .package(url: "https://github.com/smeshko/app-attest", branch: "main"),
        .package(url: "https://github.com/smeshko/id5-entities", branch: "main"),
        .package(url: "https://github.com/smeshko/id5-common", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                common, entities, vapor, fluent, prometheus, s3, attest, apns,
                .product(name: "SwiftHtml", package: "swift-html"),
                .product(name: "SwiftSvg", package: "swift-html"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "JWT", package: "jwt"),
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),

            // Workaround for https://github.com/apple/swift-package-manager/issues/6940
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "Fluent")
        ])
    ]
)

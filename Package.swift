// swift-tools-version:5.9
import PackageDescription

let fluent = Target.Dependency.product(name: "Fluent", package: "fluent")
let vapor = Target.Dependency.product(name: "Vapor", package: "vapor")
let prometheus = Target.Dependency.product(name: "SwiftPrometheus", package: "SwiftPrometheus")

let package = Package(
    name: "auth-service-template",
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
        .package(url: "https://github.com/binarybirds/swift-html", from: "1.7.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                "Common", "Entities", vapor, fluent, prometheus,
                .product(name: "SwiftHtml", package: "swift-html"),
                .product(name: "SwiftSvg", package: "swift-html"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "JWT", package: "jwt"),
            ]
        ),
        .target(name: "Entities", dependencies: [.product(name: "JWT", package: "jwt")]),
        .target(name: "Common"),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),

            // Workaround for https://github.com/apple/swift-package-manager/issues/6940
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "Fluent")
        ])
    ]
)

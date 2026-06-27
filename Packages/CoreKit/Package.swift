// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "TaskCardsDomain", targets: ["TaskCardsDomain"]),
        .library(name: "TaskCardsData", targets: ["TaskCardsData"]),
    ],
    targets: [
        .target(name: "Networking"),
        .target(name: "TaskCardsDomain"),
        .target(
            name: "TaskCardsData",
            dependencies: ["Networking", "TaskCardsDomain"],
            resources: [.process("Resources/sampleJSON.json")]
        ),
    ]
)

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PDFSplitter",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "PDFSplitter",
            targets: ["PDFSplitter"]
        )
    ],
    targets: [
        .executableTarget(
            name: "PDFSplitter",
            path: "Sources"
        )
    ]
)

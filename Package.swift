// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "unpin",
    dependencies: [
	.package(url: "https://github.com/jatoben/CommandLine", from: "3.0.0-pre1"),
	.package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.8.0")
    ],
    targets: [
        .target(
            name: "unpin",
            dependencies: ["CommandLine", "Rainbow", "Alamofire"]),
    ]
)

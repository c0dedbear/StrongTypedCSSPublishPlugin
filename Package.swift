// swift-tools-version:5.5

/**
*  StrongTypedCSS plugin for Publish
*  Copyright (c) Mikhail Medvedev 2021
*  MIT license, see LICENSE file for details
**/

import PackageDescription

let package = Package(
    name: "StrongTypedCSSPublishPlugin",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "StrongTypedCSSPublishPlugin",
            targets: ["StrongTypedCSSPublishPlugin"]),
    ],
    dependencies: [
		.package(url: "https://github.com/johnsundell/publish.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "StrongTypedCSSPublishPlugin",
            dependencies: [.product(name: "Publish", package: "publish")]),
        .testTarget(
            name: "StrongTypedCSSPublishPluginTests",
            dependencies: ["StrongTypedCSSPublishPlugin"]),
    ]
)

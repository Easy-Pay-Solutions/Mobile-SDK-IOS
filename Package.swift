// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyPay",
  platforms: [
    .iOS(.v13)
  ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EasyPay",
            targets: ["EasyPay"]),
    ],
dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.25.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EasyPay"),
	    dependencies: ["Sentry"]),

        .testTarget(
            name: "EasyPay_Tests",
            dependencies: ["EasyPay"]),
    ],
	swiftLanguageVersions: [.v5]
)

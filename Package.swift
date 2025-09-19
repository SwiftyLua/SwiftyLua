// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftyLua",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13),],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "SwiftyLua",
      targets: ["SwiftyLua"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/SwiftyLua/lua4swift", branch: "swift-6.2-port"),
    .package(url: "https://github.com/Quick/Quick", from: "7.6.2"),
    .package(url: "https://github.com/Quick/Nimble", from: "13.7.1")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "SwiftyLua",
      dependencies: [
        "lua4swift"
      ],
      swiftSettings: [
        .enableExperimentalFeature("StrictConcurrency=complete")
      ]),
    .testTarget(
      name: "SwiftyLuaTests",
      dependencies: [
        "SwiftyLua",
        "Quick",
        "Nimble"
      ],
      resources: [.copy("LuaScripts")]),
  ]
)

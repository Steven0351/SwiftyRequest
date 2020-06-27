// swift-tools-version:5.0
import PackageDescription
import Foundation

let package = Package(
  name: "SwiftyRequest",
  platforms: [.iOS(.v12), .macOS(.v10_14), .watchOS(.v3)],
  products: [
    .library(name: "SwiftyRequest", targets: ["SwiftyRequest"])
  ],
  targets: [
    .target(
      name: "SwiftyRequest",
      path: ".",
      sources: ["SwiftyRequest"]
    ),
    .testTarget(
      name: "SwiftyRequestTests",
      dependencies: ["SwiftyRequest"],
      path: ".",
      sources: ["SwiftyRequestTests"]
    )
  ]
)

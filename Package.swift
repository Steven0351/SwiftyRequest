// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "SwiftyRequest",
  products: [
    .library(name: "SwiftyRequest", targets: ["SwiftyRequest"])
  ],
  targets: [
    .target(
      name: "SwiftyRequest",
      path: "SwiftyRequest"
    ),
    .testTarget(
      name: "SwiftyRequestTests",
      dependencies: ["SwiftyRequest"],
      path: "SwiftyRequestTests"
    )
  ]
)

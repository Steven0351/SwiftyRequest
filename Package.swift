// swift-tools-version:5.0
import PackageDescription
import Foundation

let package = Package(
  name: "SwiftyRequest",
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

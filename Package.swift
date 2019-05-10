// swift-tools-version:5.0
import PackageDescription
import Foundation

func sources(at relativePath: String) -> [String] {
  let currentDirectory = String(cString: getenv("PWD"))
    return try! FileManager.default
      .contentsOfDirectory(atPath: "\(currentDirectory)/\(relativePath)")
      .filter { $0.contains(".swift") }
}

let librarySources = sources(at: "SwiftyRequest")
let testSources = sources(at: "SwiftyRequestTests")

let package = Package(
  name: "SwiftyRequest",
  products: [
    .library(name: "SwiftyRequest", targets: ["SwiftyRequest"])
  ],
  targets: [
    .target(
      name: "SwiftyRequest",
      path: "SwiftyRequest",
      sources: librarySources
    ),
    .testTarget(
      name: "SwiftyRequestTests",
      dependencies: ["SwiftyRequest"],
      path: "SwiftyRequestTests",
      sources: testSources
    )
  ]
)

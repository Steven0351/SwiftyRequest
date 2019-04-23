//
//  FatalError.swift
//  SwiftyRequest
//
//  Created by Steven Sherry on 4/22/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import Foundation

// overrides Swift global `fatalError`
public func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
  FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

/// Utility functions that can replace and restore the `fatalError` global function.
struct FatalErrorUtil {
  
  // Called by the custom implementation of `fatalError`.
  static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure
  
  // backup of the original Swift `fatalError`
  private static let defaultFatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }
  
  /// Replace the `fatalError` global function with something else.
  static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) {
    fatalErrorClosure = closure
  }
  
  /// Restore the `fatalError` global function back to the original Swift implementation
  static func restoreFatalError() {
    fatalErrorClosure = defaultFatalErrorClosure
  }
}

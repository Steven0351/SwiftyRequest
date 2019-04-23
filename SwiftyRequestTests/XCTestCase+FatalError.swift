//
//  XCTestCase+FatalError.swift
//  SwiftyRequestTests
//
//  Created by Steven Sherry on 4/22/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftyRequest

extension XCTestCase {
  func expectFatalError(expectedMessage: String, testcase: @escaping () -> Void) {
    
    let expectation = self.expectation(description: "expectingFatalError")
    var assertionMessage: String? = nil
    
    FatalErrorUtil.replaceFatalError { message, _, _ in
      assertionMessage = message
      expectation.fulfill()
      self.unreachable()
    }
    
    DispatchQueue.global(qos: .userInitiated).async(execute: testcase)
    
    waitForExpectations(timeout: 2) { _ in
      XCTAssertEqual(assertionMessage, expectedMessage)
      
      FatalErrorUtil.restoreFatalError()
    }
  }
  
  private func unreachable() -> Never {
    repeat {
      RunLoop.current.run()
    } while (true)
  }
}

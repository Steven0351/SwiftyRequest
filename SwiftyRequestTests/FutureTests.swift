//
//  FutureTests.swift
//  SwiftyRequestTests
//
//  Created by Steven Sherry on 4/21/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import XCTest
import SwiftyRequest

class FutureTests: XCTestCase {
  
  var mockSession: URLSessionMock!
  var request: Request!
  
  let endpoint = Endpoint { endpoint in
    endpoint.protocol = .https
    endpoint.host = "mockurl.com"
  }
  
  override func setUp() {
    mockSession = URLSessionMock()
    request = Request(endpoint: endpoint) { request in
      request.method = .get
    }
  }
  
  override func tearDown() {
    mockSession = nil
    request = nil
  }
  
  func testFuture_ResolvesWithFailure_WhenErrorIsRecievedFromNetworkRequest() {
    mockSession.error = RequestError.noData
    let testFuture: Future<Data> = mockSession.request(request)
    
    testFuture.observe { result in
      switch result {
      case .success:
        XCTFail("Should have received an error")
      case .failure(let error as RequestError):
        XCTAssertEqual(error, RequestError.noData)
      default:
        XCTFail(
          """
          Should have received RequestError.noData; this code path would have have been
          reached if RequestError.noData was received.
          """
        )
      }
    }
  }
  
  func testFuture_ResolvesWithSuccess_WhenValueIsReceivedFromNetworkRequest() throws {
    let mockUser = User()
    mockSession.data = try JSONEncoder().encode(mockUser)
    
    let testFuture: Future<User> = mockSession.request(request)
    
    testFuture.observe { result in
      switch result {
      case .success(let user):
        XCTAssertEqual(User(), user)
      case .failure:
        XCTFail("Should have received value")
      }
    }
  }
  
  func testFuture_ResolvesWithError_WhenDataIsMalformed() {
    let mockData = Data()
    mockSession.data = mockData
    
    let testFuture: Future<User> = mockSession.request(request)
    
    testFuture.observe { result in
      switch result {
      case .success:
        XCTFail("Should have received an error")
      case .failure(let error):
        let decodingErrorMessage = "The data couldn’t be read because it isn’t in the correct format."
        XCTAssertEqual(decodingErrorMessage, error.localizedDescription)
      }
    }
  }
  
  func testFuture_ResolvesWithError_WhenNoDataOrErrorAreReturned() {
    let testFuture: Future<User> = mockSession.request(request)
    
    testFuture.observe { result in
      switch result {
      case .success:
        XCTFail("Should have received an error")
      case .failure(let error as RequestError):
        XCTAssertEqual(RequestError.noData, error)
      default:
        XCTFail(
          """
          Should have received RequestError.noData; this code path would have have been
          reached if RequestError.noData was received.
          """
        )
      }
    }
  }
  
}

// MARK: - Test Fixtures

struct User: Codable, Equatable {
  let name: String = "Steven0351"
}

class URLSessionDataTaskMock: URLSessionDataTask {
  let closure: () -> ()
  init(_ closure: @escaping () -> ()) {
    self.closure = closure
  }
  
  override func resume() {
    closure()
  }
}

class URLSessionMock: URLSession {
  var data: Data?
  var error: Error?
  
  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    return URLSessionDataTaskMock { [unowned self] in
      print("this is using the mock dataTask(with:completionHandler:) override")
      completionHandler(self.data, nil, self.error)
    }
  }
}

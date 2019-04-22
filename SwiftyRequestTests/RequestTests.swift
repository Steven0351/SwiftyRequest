//
//  RequestTests.swift
//  SwiftyRequestTests
//
//  Created by Steven Sherry on 4/18/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import XCTest
import SwiftyRequest

class RequestTests: XCTestCase {
   
  func test_RequestEqualsURLRequest_usingConfigInitializerWithConveninceFunction() {
    let endpoint = Endpoint { endpoint in
      endpoint.protocol = .https
      endpoint.host = "www.myapi.com"
      endpoint.pathComponents = ["api", "v1", "users"]
    }
    
    let request = Request(endpoint: endpoint) { request in
      request.method = .get
      request.set(value: "Bearer ==wqeoriuj943ru8sajdf", for: .authorization)
    }
    
    var urlRequest = URLRequest(url: endpoint.url!)
    urlRequest.setValue("Bearer ==wqeoriuj943ru8sajdf", forHTTPHeaderField: "Authorization")
    urlRequest.httpMethod = "GET"
    
    XCTAssertNotNil(request)
    XCTAssertEqual(urlRequest, request)
  }
  
  func test_RequestEqualsURLRequest_usingConfigInitializerWithHeaderFields() {
    let endpoint = Endpoint { endpoint in
      endpoint.protocol = .https
      endpoint.host = "www.myapi.com"
      endpoint.pathComponents = ["api", "v1", "users"]
    }
    
    let request = Request(endpoint: endpoint) { request in
      request.method = .get
      request.headerFields = [.authorization: "Bearer ==wqeoriuj943ru8sajdf"]
    }
    
    var urlRequest = URLRequest(url: endpoint.url!)
    urlRequest.setValue("Bearer ==wqeoriuj943ru8sajdf", forHTTPHeaderField: "Authorization")
    urlRequest.httpMethod = "GET"
    
    XCTAssertNotNil(request)
    XCTAssertEqual(urlRequest, request)
  }
  
  func test_RequestIsNil_whenEndpointIsMisconfigured() {
    let endpoint = Endpoint { endpoint in
      endpoint.protocol = .https
      endpoint.host = "google.com"
      endpoint.path = "auth/login"
    }
    let request = Request(endpoint: endpoint)
    
    XCTAssertNil(request)
  }
  
  func test_RequestMethodReturnsDotPut_whenHttpMethodSetDirectly() {
    let endpoint = Endpoint { _ in }
    let request = Request(endpoint: endpoint) { request in
      request.httpMethod = "PUT"
    }
    
    XCTAssertEqual(request!.method, .put)
  }
  
  func test_RequestMethodReturnsNil_whenHttpMethodSetWithUnsupportedMethod() {
    let endpoint = Endpoint { _ in }
    let request = Request(endpoint: endpoint) { request in
      request.httpMethod = "HEAD"
    }
    
    XCTAssertNil(request?.method)
  }
  
  func test_RequestMethodReturnsdoGet_whenHttpMethodNotSet() {
    let endpoint = Endpoint { _ in }
    let request = Request(endpoint: endpoint)
    
    XCTAssertEqual(request!.method, .get)
  }
  
  func test_RequestHeaderFields_whenUsingSetMethod() {
    let endpoint = Endpoint { endpoint in
      endpoint.protocol = .https
      endpoint.host = "www.myapi.com"
      endpoint.pathComponents = ["api", "v1", "users"]
    }
    
    let request = Request(endpoint: endpoint) { request in
      request.method = .get
      request.set(value: "Bearer ==wqeoriuj943ru8sajdf", for: .authorization)
    }
    
    XCTAssertEqual(request!.headerFields, [.authorization: "Bearer ==wqeoriuj943ru8sajdf"])
  }
  
  func test_addValueSetsAuthorization_whenAuthorizationIsNotSet() {
    let endpoint = Endpoint { endpoint in
      endpoint.protocol = .https
      endpoint.host = "www.myapi.com"
      endpoint.pathComponents = ["api", "v1", "users"]
    }
    
    let request = Request(endpoint: endpoint) { request in
      request.method = .get
      request.add(value: "Bearer ==wqeoriuj943ru8sajd9", for: .authorization)
    }
    
    XCTAssertEqual(request!.value(for: .authorization), "Bearer ==wqeoriuj943ru8sajd9")
  }
  
}

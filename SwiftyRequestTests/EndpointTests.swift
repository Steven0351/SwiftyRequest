//
//  SwiftyRequestTests.swift
//  SwiftyRequestTests
//
//  Created by Steven Sherry on 4/10/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import XCTest
@testable import SwiftyRequest

class EndpointTests: XCTestCase {
  
  func testEndpoint_ReturnHTTPSAsProtocol_WhenSchemeIsSetDirectly() {
    let endpoint = Endpoint { endpoint in
      endpoint.scheme = "https"
    }
    
    XCTAssertEqual(endpoint.protocol!, Endpoint.TransportProtocol.https)
  }
  
  func testEndpoint_ReturnsNilProtocol_WhenSchemeIsSetWithUnsupportedScheme() {
    let endpoint = Endpoint { endpoint in
      endpoint.scheme = "ws"
    }
    
    XCTAssertNil(endpoint.protocol)
  }
  
  func testEndpoint_ReturnsNilProtocol_WhenSchemeIsNotSet() {
    let endpoint = Endpoint { _ in }
    
    XCTAssertNil(endpoint.protocol)
  }
  
  func testEndpoint_GeneratesCorrectUrl_WithConvenienceProperties() {
    let expectedUrl = "https://www.myapi.com/api/v1/users"
    
    let endpoint = Endpoint { endpoint in
      endpoint.protocol = .https
      endpoint.host = "www.myapi.com"
      endpoint.pathComponents = ["api", "v1", "users"]
    }
    
    XCTAssertEqual(expectedUrl, endpoint.description)
  }
  
  func testEndpoint_CreatesNewEndpoint_AfterAppendingNewPathComponents() {
    let expectedBase = "https://www.myapi.com/api/v1"
    let expectedUrl = "https://www.myapi.com/api/v1/users"
    
    let baseEndpoint = Endpoint { base in
      base.protocol = .https
      base.host = "www.myapi.com"
      base.pathComponents = ["api", "v1"]
    }
    
    let usersEndpoint = baseEndpoint.appending(pathComponents: ["users"])
    
    XCTAssertEqual(expectedBase, baseEndpoint.description)
    XCTAssertEqual(expectedUrl, usersEndpoint.description)
  }
  
  func testEndpoint_CreatesNewEndpoint_AfterAppendingNewPathComponent() {
    let expectedBase = "https://www.myapi.com/api/v1"
    let expectedUrl = "https://www.myapi.com/api/v1/users"
    
    let baseEndpoint = Endpoint { base in
      base.protocol = .https
      base.host = "www.myapi.com"
      base.pathComponents = ["api", "v1"]
    }
    
    let usersEndpoint = baseEndpoint.appending(pathComponent: "users")
    
    XCTAssertEqual(expectedBase, baseEndpoint.description)
    XCTAssertEqual(expectedUrl, usersEndpoint.description)
  }
  
  func testEndpoint_CreatesQueryUrl_WithConvenienceFunctions() {
    let queryColor = Query.partialInit(key: "color")
    let querySize = Query.partialInit(key: "size")
    
    let expectedUrl = "https://www.myapi.com/api/v1/users?color=red&size=small"
    
    let endpoint = Endpoint { endpoint in
      endpoint.protocol = .https
      endpoint.host = "www.myapi.com"
      endpoint.pathComponents = ["api", "v1", "users"]
      endpoint.queryItems = [queryColor("red"), querySize("small")]
    }
    
    XCTAssertEqual(expectedUrl, endpoint.description)
  }
  
  func testEndpoint_CreatesNewEndpoint_AfterAppendingNewQuery() {
    let expectedBase = "https://www.myapi.com/api/v1/users"
    let expectedUrl = "https://www.myapi.com/api/v1/users?name=steven"
    
    let baseEndpoint = Endpoint { base in
      base.protocol = .https
      base.host = "www.myapi.com"
      base.pathComponents = ["api", "v1", "users"]
    }
    
    let queryEndpoint = baseEndpoint.appending(query: Query(name: "name", value: "steven"))
    
    XCTAssertEqual(expectedBase, baseEndpoint.description)
    XCTAssertEqual(expectedUrl, queryEndpoint.description)
  }
  
  func testEndpoint_CreatesNewEndpointWithAdditionalQueries_AfterAppendingNewQueries() {
    let expectedBase = "https://www.myapi.com/api/v1/users?name=steven"
    let expectedUrl = "https://www.myapi.com/api/v1/users?name=steven&haircolor=red&pets=true"
    
    let baseEndpoint = Endpoint { base in
      base.protocol = .https
      base.host = "www.myapi.com"
      base.pathComponents = ["api", "v1", "users"]
      base.queryItems = [Query(name: "name", value: "steven")]
    }
    
    let queryEndpoint = baseEndpoint.appending(queries:
      [URLQueryItem(name: "haircolor", value: "red"), Query(name: "pets", value: "true")]
    )
    
    XCTAssertEqual(expectedBase, baseEndpoint.description)
    XCTAssertEqual(expectedUrl, queryEndpoint.description)
  }
}

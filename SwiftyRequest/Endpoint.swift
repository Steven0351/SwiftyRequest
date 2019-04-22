//
//  Endpoint.swift
//  SwiftyRequest
//
//  Created by Steven Sherry on 4/18/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import Foundation

public typealias Endpoint = URLComponents

public extension Endpoint {
  init(_ configBlock: (inout URLComponents) -> ()) {
    self.init()
    configBlock(&self)
  }
  
  enum TransportProtocol: String {
    case http, https
  }
  
  var `protocol`: TransportProtocol? {
    get {
      return TransportProtocol(rawValue: scheme ?? "")
    }
    set {
      self.scheme = newValue?.rawValue
    }
  }
  
  var pathComponents: [String] {
    get {
      return path
        .split(separator: "/")
        .map(String.init)
    }
    set {
      path = "/" + newValue.joined(separator: "/")
    }
  }
  
  func appending(pathComponents: [String]) -> Endpoint {
    var copy = self
    copy.pathComponents.append(contentsOf: pathComponents)
    return copy
  }
  
  func appending(pathComponent: String) -> Endpoint {
    return appending(pathComponents: [pathComponent])
  }
  
  func appending(queries: [Query]) -> Endpoint {
    var copy = self
    copy.queryItems == nil ? copy.queryItems = queries : copy.queryItems?.append(contentsOf: queries)
    return copy
  }
  
  func appending(query: Query) -> Endpoint {
    return appending(queries: [query])
  }
}

public typealias Query = URLQueryItem

public extension Query {
  static func partialInit(key: String) -> (String) -> URLQueryItem {
    return { value in
      URLQueryItem(name: key, value: value)
    }
  }
}

//
//  Request.swift
//  SwiftyRequest
//
//  Created by Steven Sherry on 4/10/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import Foundation

public typealias Request = URLRequest

public extension Request {
  init(endpoint: Endpoint, _ configBlock: ((inout Request) -> ())? = nil) {
    guard let url = endpoint.url else { fatalError("endpoint does not synthesize a valid url") }
    self.init(url: url)
    configBlock?(&self)
  }
  
  var method: Method? {
    get {
      return Method(rawValue: httpMethod?.lowercased() ?? "")
    }
    set {
      httpMethod = newValue?.headerString
    }
  }
  
  var headerFields: [Header: String]? {
    get {
      return allHTTPHeaderFields.map { dictionary in
        Dictionary(uniqueKeysWithValues: dictionary.compactMap { key, value in
          guard let key = Header(rawValue: key) else { return nil }
          return (key, value)
        })
      }
    }
    set {
      newValue?.forEach { (header, value) in
        setValue(value, forHTTPHeaderField: header.rawValue)
      }
    }
  }
  
  mutating func add(value: String, for header: Header) {
    addValue(value, forHTTPHeaderField: header.rawValue)
  }
  
  mutating func set(value: String, for header: Header) {
    setValue(value, forHTTPHeaderField: header.rawValue)
  }
  
  func value(for header: Header) -> String? {
    return value(forHTTPHeaderField: header.rawValue)
  }
  
  enum Method: String {
    case get, post, put, patch, delete
    
    var headerString: String {
      return self.rawValue.uppercased()
    }
  }
  
  enum Header: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case accept = "Accept"
  }
}

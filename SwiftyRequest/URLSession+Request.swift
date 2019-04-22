//
//  URLSession+Request.swift
//  SwiftyRequest
//
//  Created by Steven Sherry on 4/19/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import Foundation

public extension URLSession {
  func request<T: Decodable>(_ request: Request) -> Future<T> {
    let promise = Promise<T>()
    
    let task = dataTask(with: request) { data, _, error in
      if let error = error { return promise.reject(with: error) }
      
      guard let data = data else { return promise.reject(with: RequestError.noData) }
      
      do {
        let value = try JSONDecoder().decode(T.self, from: data)
        promise.resolve(with: value)
      } catch let error {
        promise.reject(with: error)
      }
    }
    
    task.resume()
    return promise
  }
}

//
//  Future.swift
//  SwiftyRequest
//
//  Created by Steven Sherry on 4/19/19.
//  Copyright © 2019 Steven Sherry. All rights reserved.
//

import Foundation

public class Future<T> {
  fileprivate var result: Result<T, Error>? {
    didSet {
      result.map(report)
    }
  }
  
  private lazy var observations = [(Result<T, Error>) -> ()]()
  
  public func observe(_ callback: @escaping (Result<T, Error>) -> ()) {
    observations.append(callback)
    result.map(callback)
  }
  
  private func report(result: Result<T, Error>) {
    observations.forEach { observe in
      observe(result)
    }
  }
}

class Promise<T>: Future<T> {
  init(value: T? = nil) {
    super.init()
    result = value.map { value in
      Result.success(value)
    }
  }

  func resolve(with value: T) {
    result = .success(value)
  }

  func reject(with error: Error) {
    result = .failure(error)
  }
}

//
//  Network Support.swift
//  Square
//
//  Created by Yariv Nissim on 3/16/21.
//

import Foundation

enum Endpoint: String {
  case directory = "employees"
  case directoryMalformed = "employees_malformed"
  case directoryEmpty = "employees_empty"
}

struct Service {
  private(set) var baseURL: String
  
  /// - note: Support injecting the environment for dev and testing purposes
  internal init(env: Environment = .prod) {
    self.baseURL = env.rawValue
  }

  // MARK: Get URL
  
  func url(endpoint: Endpoint) -> URL {
    let urlString = baseURL + endpoint.rawValue + ".json"
    
    let url = URL(string: urlString)
    assert(url != nil, "The endpoint URL should never return nil")
    return url!
  }
}

enum Environment: String {
  case prod = "https://s3.amazonaws.com/sq-mobile-interview/"
  
  // warning: Mock Value! Do not actually use"
  case test = "https://test.s3.amazonaws.com/sq-mobile-interview/"
  case dev = "https://dev.s3.amazonaws.com/sq-mobile-interview/"
}

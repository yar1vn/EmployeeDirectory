//
//  NetworkController.swift
//  Square
//
//  Created by Yariv Nissim on 3/16/21.
//

import Foundation
import Combine

final class NetworkController {
  static let shared = NetworkController()
  
  let service: Service
  
  init(service: Service = .init()) {
    self.service = service
  }
}

extension NetworkController {

  /// Create a publisher to fetch Employee Directory
  ///
  /// - parameter endpoint: Inject the endpoint for testing
  /// - returns: A publisher with array of `Employee` objects or `Error`
  ///
  func employeeDirectoryPublisher(endpoint: Endpoint = .directory) -> AnyPublisher<[Employee], Error> {
    return URLSession.shared
      .dataTaskPublisher(for: service.url(endpoint: endpoint))
      .map(\.data)
      .decode(type: Directory.self, decoder: JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase))
      .map(\.employees)
      .eraseToAnyPublisher()
  }
}

// MARK:- Private Extensions

private extension JSONDecoder {
  // Why is this not built in?
  convenience init(keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys) {
    self.init()
    self.keyDecodingStrategy = keyDecodingStrategy
  }
}

//
//  NetworkController.swift
//  Square
//
//  Created by Yariv Nissim on 3/16/21.
//

import Foundation
import Combine
import UIKit.UIImage

final class NetworkController {
    private lazy var sessionWithCache: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = URLCache(count: 1000) // Estimated cache size.
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad // Use cache when available.
        
        let session = URLSession(configuration: sessionConfig)
        return session
    }()
    
    let service: Service
    let endpoint: Endpoint
    
    init(service: Service = .init(), endpoint: Endpoint = .directory) {
        self.service = service
        self.endpoint = endpoint
    }
}

extension NetworkController {
    
    /// Create a publisher to fetch Employee Directory
    ///
    /// - parameter endpoint: Inject the endpoint for testing
    /// - returns: A publisher with array of `Employee` objects or `Error`
    ///
    func employeeDirectoryPublisher() -> AnyPublisher<[Employee], Error> {
        return URLSession.shared
            .dataTaskPublisher(for: service.url(endpoint: endpoint))
            .map(\.data)
            .decode(type: Directory.self, decoder: JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase))
            .map(\.employees)
            .eraseToAnyPublisher()
    }
    
    /// Create a publisher to fetch Photos for Employee
    ///
    /// - parameter employees: Array of `Employee` objects
    /// - returns: Employee View Model with valid information and photo
    ///
    func employeesWithPhotosPublisher(employees: [Employee]) -> AnyPublisher<EmployeeViewModel, Never> {
        Publishers.MergeMany(
            employees.compactMap { employee in
                imagePublisher(imageURL: employee.photoUrlSmall)
                    .compactMap { EmployeeViewModel(employee: employee, photo: $0) }
                    .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
    
    // Use `sessionWithCache` to automatically cache photo data per url
    // This saves us the trouble of managing our own disk cache
    private func imagePublisher(imageURL: URL?) -> AnyPublisher<UIImage?, Never> {
        guard let imageURL = imageURL else {
            return Just(nil).eraseToAnyPublisher() // support empty images
        }
        
        return sessionWithCache
            .dataTaskPublisher(for: imageURL)
            .map(\.data)
            .replaceError(with: Data())
            .compactMap(UIImage.init(data:))
            .eraseToAnyPublisher()
    }
}

// MARK:- Private Extensions

private extension URLCache {
    
    /// Initialize a URLCache with local disk storage
    ///
    /// - parameter count: Estimated number of objects to save in the cache
    /// - note: This amount needs to big much bigger than the actual file size for the cache to work.
    ///         That's why I'm estimating 1mb, it doesn't actually use that much storage on the device.
    ///         The cache will manage it's own storage space for us.
    convenience init(count: Int) {
        // 1mb * count -> bytes
        let storageCapacity = count *
            Int(Measurement(value: 1, unit: UnitInformationStorage.megabytes)
                    .converted(to: .bytes).value)
        self.init(memoryCapacity: storageCapacity, diskCapacity: storageCapacity * 10)
    }
}

private extension JSONDecoder {
    // Why is this not built in?
    convenience init(keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}

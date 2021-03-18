//
//  ViewModel.swift
//  Square
//
//  Created by Yariv Nissim on 3/16/21.
//

import Foundation
import Combine
import UIKit.UIImage

class EmployeeDirectory: ObservableObject {
    let networkController: NetworkControllerProtocol
    
    init(networkController: NetworkControllerProtocol = NetworkController()) {
        self.networkController = networkController
    }
    
    func fetch() -> AnyPublisher<FetchState, Never> {
        return networkController
            .employeeDirectoryPublisher() // fetch the employee directory
            .flatMap(networkController.employeesWithPhotosPublisher(employees:)) // load and cache employee small photos
            .collect()
            .map { $0.sorted { a, b in a.fullName < b.fullName }} // sort by name
            .map { FetchState.success($0) } // map employee array to FetchState.success
            .catch { Just(FetchState.failure($0)) } // map error to FetchState.failure
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum FetchState {
    case success([EmployeeViewModel])
    case failure(Error)
    case none
}

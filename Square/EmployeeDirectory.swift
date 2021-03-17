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
    let networkController: NetworkController
    
    init(networkController: NetworkController = NetworkController()) {
        self.networkController = networkController
    }
    
    func fetch() -> AnyPublisher<FetchState, Never> {
        return networkController
            .employeeDirectoryPublisher()
            .flatMap(networkController.employeesWithPhotosPublisher(employees:))
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

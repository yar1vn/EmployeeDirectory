//
//  MockNetworkController.swift
//  SquareTests
//
//  Created by Yariv Nissim on 3/17/21.
//

import Foundation
import Combine
@testable import Square

class MockNetworkController: NetworkControllerProtocol {
    func employeeDirectoryPublisher() -> AnyPublisher<[Employee], Error> {
        Just([testEmployee, testEmployee2])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func employeesWithPhotosPublisher(employees: [Employee]) -> AnyPublisher<EmployeeViewModel, Never> {
        Publishers.MergeMany(
            employees
                .compactMap { EmployeeViewModel(employee: $0, photo: nil) }
                .map(Just.init)
        )
        .eraseToAnyPublisher()
    }
}

class MockNetworkControllerFail: NetworkControllerProtocol {
    func employeeDirectoryPublisher() -> AnyPublisher<[Employee], Error> {
        Fail(error: NSError(domain: "MockNetworkControllerFail", code: 0, userInfo: nil))
            .eraseToAnyPublisher()
    }
    
    func employeesWithPhotosPublisher(employees: [Employee]) -> AnyPublisher<EmployeeViewModel, Never> {
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}

let testEmployee =
    Employee(uuid: "1",
             fullName: "barbara",
             phoneNumber: "",
             emailAddress: "",
             biography: "",
             photoUrlSmall: nil,
             photoUrlLarge: nil,
             team: "",
             employeeType: .fullTime)

let testEmployee2 =
    Employee(uuid: "2",
             fullName: "albert",
             phoneNumber: "",
             emailAddress: "",
             biography: "",
             photoUrlSmall: nil,
             photoUrlLarge: nil,
             team: "",
             employeeType: .partTime)

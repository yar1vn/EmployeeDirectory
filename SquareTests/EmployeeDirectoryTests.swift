//
//  EmployeeDirectoryTests.swift
//  SquareTests
//
//  Created by Yariv Nissim on 3/17/21.
//

import XCTest
import Combine
@testable import Square

class EmployeeDirectoryTests: XCTestCase {
    var cancellable: AnyCancellable?
    
    func testFetchDirectory() {
        let expectation = self.expectation(description: "Directory fetched successfully with 2 employees")
        let directory = EmployeeDirectory(networkController: MockNetworkController())
        
        cancellable = directory
            .fetch()
            .sink { state in
                if case let .success(employees) = state {
                    XCTAssertFalse(employees.isEmpty)
                    XCTAssertEqual(employees.count, 2)
                    
                    // check sort by fullname
                    XCTAssertEqual(employees[0].fullName, "albert")
                    XCTAssertEqual(employees[1].fullName, "barbara")
                    
                    expectation.fulfill()
                }
            }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

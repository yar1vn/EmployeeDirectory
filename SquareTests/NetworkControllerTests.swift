//
//  NetworkControllerTests.swift
//  SquareTests
//
//  Created by Yariv Nissim on 3/17/21.
//

import XCTest
import Combine
@testable import Square

class NetworkControllerTests: XCTestCase {
    var cancellable: AnyCancellable?
    
    func testLoadingEmployeeDirectorySuccess() {
        let expectation = self.expectation(description: "Receive 2 employees and complete without errors")
        expectation.expectedFulfillmentCount = 2
        
        cancellable = MockNetworkController().employeeDirectoryPublisher()
            .sink(receiveCompletion: { (completion) in
                if case .finished = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { (employees) in
                if employees.count == 2 {
                    expectation.fulfill()
                }
            })
        
        waitForExpectations(timeout: 0, handler: nil)
    }
    
    func testLoadingEmployeeDirectoryFail() {
        let expectation = self.expectation(description: "Receive no employees and complete with error")
        expectation.isInverted = true // inverted means no fulfillments are expected
        
        cancellable = MockNetworkControllerFail().employeeDirectoryPublisher()
            .sink(receiveCompletion: { (completion) in
                if case .finished = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { (employees) in
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 0, handler: nil)
    }   
}

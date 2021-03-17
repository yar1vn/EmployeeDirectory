//
//  ModelTests.swift
//  SquareTests
//
//  Created by Yariv Nissim on 3/17/21.
//

import XCTest
@testable import Square

class ViewModelTests: XCTestCase {
    func testValidEmployee() throws {
        let employee = Employee(uuid: "id",
                                fullName: "name",
                                phoneNumber: "number",
                                emailAddress: "email",
                                biography: "bio",
                                photoUrlSmall: nil,
                                photoUrlLarge: nil,
                                team: "team",
                                employeeType: .fullTime)
        
        let viewModel = EmployeeViewModel(employee: employee, photo: nil)
        
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel?.id, employee.uuid)
        XCTAssertEqual(viewModel?.fullName, employee.fullName)
        XCTAssertEqual(viewModel?.teamName, employee.team)
        XCTAssertEqual(viewModel?.smallPhoto, nil)
    }
    
    func testInvalidEmployee() throws {
        let employee = Employee(uuid: "id",
                                fullName: nil, // this field is required for ViewModel
                                phoneNumber: "number",
                                emailAddress: "email",
                                biography: "bio",
                                photoUrlSmall: nil,
                                photoUrlLarge: nil,
                                team: "team",
                                employeeType: .fullTime)
        
        let viewModel = EmployeeViewModel(employee: employee, photo: nil)
        XCTAssertNil(viewModel)
    }
}

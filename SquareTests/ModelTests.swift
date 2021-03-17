//
//  ModelTests.swift
//  SquareTests
//
//  Created by Yariv Nissim on 3/17/21.
//

import XCTest
@testable import Square

class ModelTests: XCTestCase {
    
    private let decoder: JSONDecoder = {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        return $0
    }(JSONDecoder())
    
    func testValidEmployee() throws {
        let employee = try decoder.decode(Employee.self, from: validEmployeeData)
        XCTAssertEqual(employee.uuid, "0d8fcc12-4d0c-425c-8355-390b312b909c")
        XCTAssertEqual(employee.fullName, "Justine Mason")
        XCTAssertEqual(employee.phoneNumber, "5553280123")
        XCTAssertEqual(employee.emailAddress, "jmason.demo@squareup.com")
        XCTAssertEqual(employee.biography, "Engineer on the Point of Sale team.")
        XCTAssertEqual(employee.photoUrlSmall?.absoluteString, "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg")
        XCTAssertEqual(employee.photoUrlLarge?.absoluteString, "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg")
        XCTAssertEqual(employee.team, "Point of Sale")
        XCTAssertEqual(employee.employeeType, .fullTime)
    }
    
    func testInvalidEmployee() throws {
        XCTAssertThrowsError(try decoder.decode(Employee.self, from: invalidEmployeeData))
    }
}

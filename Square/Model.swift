//
//  Model.swift
//  Square
//
//  Created by Yariv Nissim on 3/16/21.
//

import Foundation

// ❗️ This code was generated using quicktype app to save time.
// I used Paw to get test the endpoints and copy the json responses.

// https://apps.apple.com/us/app/paste-json-as-code-quicktype/id1330801220?mt=12
// http://paw.cloud

// MARK: - Directory
struct Directory: Codable {
    let employees: [Employee]

    enum CodingKeys: String, CodingKey {
        case employees
    }
}

// MARK: - Employee
struct Employee: Codable {
    let uuid: String?
    let fullName: String?
    let phoneNumber: String?
    let emailAddress: String?
    let biography: String?
    let photoUrlSmall: String?
    let photoUrlLarge: String?
    let team: String?
    let employeeType: EmployeeType?

    enum CodingKeys: String, CodingKey {
        case uuid
        case fullName
        case phoneNumber
        case emailAddress
        case biography
        case photoUrlSmall
        case photoUrlLarge
        case team
        case employeeType
    }
}

enum EmployeeType: String, Codable {
    case contractor = "CONTRACTOR"
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
}

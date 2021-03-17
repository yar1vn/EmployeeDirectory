//
//  ViewModel.swift
//  Square
//
//  Created by Yariv Nissim on 3/17/21.
//

import Foundation
import UIKit.UIImage

struct EmployeeViewModel: Hashable {
    let id: String
    let fullName: String
    let teamName: String?
    let smallPhoto: UIImage?
    
    init?(employee: Employee, photo: UIImage?) {
        guard let fullName = employee.fullName else {
            return nil
        }
        
        self.id = employee.uuid
        self.fullName = fullName
        self.teamName = employee.team
        self.smallPhoto = photo
    }
}

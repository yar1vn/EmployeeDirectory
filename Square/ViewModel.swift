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
        guard let id = employee.uuid,
              let fullName = employee.fullName
        else {
            return nil
        }
        
        self.id = id
        self.fullName = fullName
        self.teamName = employee.team
        self.smallPhoto = photo
    }
}

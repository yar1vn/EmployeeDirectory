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
    @Published private(set) var progress: Progress?
    let networkController: NetworkController
    
    init(networkController: NetworkController = NetworkController()) {
        self.networkController = networkController
    }
    
    func fetch() -> AnyPublisher<FetchState, Never> {
        progress = Progress()
        
        return networkController
            .employeeDirectoryPublisher()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [self] employees in
                guard let progress = progress else { return }
                // The completed first step was downloading the employee directory
                progress.totalUnitCount = Int64(employees.count) + 1
                progress.completedUnitCount = 1
            })
            .flatMap(networkController.employeesWithPhotosPublisher(employees:))
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [self] employee in
                guard let progress = progress else { return }
                
                // Update the progress for each employee photo downloaded
                progress.completedUnitCount += 1
                progress.localizedDescription = "Downloading \(progress.completedUnitCount-1) out of \(progress.totalUnitCount-1) Employees"
            }, receiveCompletion: { [progress] _ in
                guard let progress = progress else { return }
                progress.completedUnitCount = progress.totalUnitCount
            })
            .collect()
            .map { $0.sorted { a, b in a.fullName < b.fullName }} // sort by name
            .map { FetchState.success($0) } // map employee array to FetchState.success
            .catch { Just(FetchState.failure($0)) } // map error to FetchState.failure
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.progress = nil // reset progress when done
            })
            .eraseToAnyPublisher()
    }
}

enum FetchState {
    case loading(Progress)
    case success([EmployeeViewModel])
    case failure(Error)
}

struct EmployeeViewModel: Hashable {
    let id: String
    let fullName: String
    let smallPhoto: UIImage
    let teamName: String
    
    init(employee: Employee, photo: UIImage) {
        self.id = employee.uuid
        self.fullName = employee.fullName
        self.teamName = employee.team
        self.smallPhoto = photo
    }
}

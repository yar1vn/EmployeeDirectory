//
//  ViewController.swift
//  Square
//
//  Created by Yariv Nissim on 3/16/21.
//

import UIKit
import Combine

/*
 TODO:
 - Model + ViewModel √
 - Network layer √
 - Image Cache √
 - Basic UI - Collection View + Diffable √
 - Customize UI - Rounded Corners √
 - Handle Error and Empty State
 - Unit Tests
 */

class EmployeesViewController: UIViewController {
    private let directory = EmployeeDirectory(
        networkController: NetworkController(endpoint: .directory)
    )
    private var state: FetchState = .none {
        didSet { updateUI() }
    }
    
    private var cancellable: AnyCancellable?
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, EmployeeViewModel>!
    private var refreshControl: UIRefreshControl!
    
    // MARK:- View lifecycle
    
    override func loadView() {
        view = createCollectionView()
        createDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDirectory()
    }
    
    private func loadDirectory() {
        refreshControl.beginRefreshing()
        
        cancellable = directory
            .fetch()
            .sink(receiveValue: { [weak self] state in
                guard let self = self else { return }
                self.state = state
                self.refreshControl.endRefreshing()
            })
    }
    
    private func updateUI() {
        switch state {
        case let .success(employees):
            var snapshot = NSDiffableDataSourceSectionSnapshot<EmployeeViewModel>()
            snapshot.append(employees)
            dataSource.apply(snapshot, to: 0, animatingDifferences: true)
            
        case let .failure(error):
            print(error)
            
        case .none:
            break
        }
    }
}

// MARK:- UICollectionView functions

extension EmployeesViewController {
    
    private func createCollectionView() -> UICollectionView {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        refreshControl = UIRefreshControl(
            frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
                self?.loadDirectory()
            })
        )
        collectionView.refreshControl = refreshControl
        return collectionView
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func createDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, EmployeeViewModel> { cell, indexPath, employee in
            
            var configuration = cell.defaultContentConfiguration()
            configuration.text = employee.fullName
            configuration.image = employee.smallPhoto
            configuration.secondaryText = employee.teamName
            configuration.imageProperties.cornerRadius = 13
            configuration.imageProperties.maximumSize = .init(width: 100, height: 100)
            configuration.imageProperties.reservedLayoutSize = configuration.imageProperties.maximumSize // align all images regardless of actual size
            cell.contentConfiguration = configuration
        }
        
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
}

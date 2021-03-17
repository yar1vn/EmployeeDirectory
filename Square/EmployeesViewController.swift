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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        createDataSource()
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
    
    private func resetUI() {
        emptyStack?.removeFromSuperview()
    }
    
    private func updateUI() {
        resetUI()
        
        switch state {
        case let .success(employees) where employees.isEmpty:
            emptyState(title: NSLocalizedString("Employee Directory is Empty.", comment: "Placeholder text when no employees are found."))
        
        case let .success(employees):
            var snapshot = NSDiffableDataSourceSectionSnapshot<EmployeeViewModel>()
            snapshot.append(employees)
            dataSource.apply(snapshot, to: 0, animatingDifferences: true)
            
        case let .failure(error):
            let localizedTitle = NSLocalizedString("We Encountered an Error Loading the Employee Directory.", comment: "Placeholder text when error is encountered.")
            emptyState(title: localizedTitle +
                        "\n\n (\(error.localizedDescription))", isError: true)
            
        case .none:
            resetUI()
        }
    }
    
    private var emptyStack: UIStackView?
    
    private func emptyState(title: String, isError: Bool = false) {
        let label = UILabel()
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = isError ? .systemRed : .label
        label.textAlignment = .center
        
        let image = UIImage(systemName: "square.fill")?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.axis = .vertical
        stack.alignment = .center
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            stack.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0),
        ])
        stack.sizeToFit()
        emptyStack = stack
    }
}

// MARK:- UICollectionView functions

extension EmployeesViewController {
    
    private func createCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        refreshControl = UIRefreshControl(
            frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
                self?.loadDirectory()
            })
        )
        collectionView.refreshControl = refreshControl
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
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

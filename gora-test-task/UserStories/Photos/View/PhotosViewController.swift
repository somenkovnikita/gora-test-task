//
//  PhotosViewController.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import UIKit

final class PhotosViewController: UIViewController {

    // MARK: - Public Properties

    var output: PhotosViewOutput?

    // MARK: - Subviews

    private var tableView = UITableView()
    private var activityIndicatorView = UIActivityIndicatorView()

    // MARK: - Private Properties

    private lazy var dataSource = DataSource.create(tableView: tableView)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureAppearance()
        self.output?.ready()
    }

    // MARK: - Actions

}

// MARK: - Public Methods

extension PhotosViewController {

}

// MARK: - PhotosViewInput

extension PhotosViewController: PhotosViewInput {

    func configure(state: State<[PhotoCellViewModel]>) {
        switch state {
        case .loading:
            configureLoadingState()
        case .error:
            configureErrorState()
        case .data(let viewModels):
            configureViewModels(viewModels)
        case .empty:
            configureEmptyState()
        }
    }

}

// MARK: - Private methods

private extension PhotosViewController {

    private func configureAppearance() {
        configureView()
        configureSubviews()
        configureNavigation()
        configureConstraints()
        configureInitialState()
    }

    private func configureNavigation() {
        navigationItem.title = "Photos"
    }

    private func configureView() {
        tableView.dataSource = dataSource
        tableView.delegate = self

        tableView.register(PhotoCell.self)
        tableView.backgroundView = activityIndicatorView

        tableView.separatorStyle = .none

        dataSource.apply(Snapshot(), animatingDifferences: false)
    }

    private func configureSubviews() {
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func configureInitialState() {

    }

    private func configureLoadingState() {
        activityIndicatorView.startAnimating()
    }

    private func configureErrorState() {
        activityIndicatorView.stopAnimating()
    }

    private func configureViewModels(_ viewModels: [PhotoCellViewModel]) {
        activityIndicatorView.stopAnimating()

        var snapshot = Snapshot()

        let cells: [Cell] = viewModels.map { .photoCell($0) }

        snapshot.appendSections([.main])
        snapshot.appendItems(cells, toSection: .main)

        dataSource.apply(snapshot)
    }

    private func configureEmptyState() {
        activityIndicatorView.stopAnimating()
    }

}

extension PhotosViewController: UITableViewDelegate {

}

private enum Section {

    case main

}

private enum Cell: Hashable {

    case photoCell(PhotoCellViewModel)

}

private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Cell>

private final class DataSource: UITableViewDiffableDataSource<Section, Cell> {

    static func create(tableView: UITableView) -> DataSource {
        DataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .photoCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withClass: PhotoCell.self, for: indexPath)
                cell.configure(with: viewModel)
                return cell
            }
        }
    }

}

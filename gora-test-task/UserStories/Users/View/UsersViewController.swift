//
//  UsersViewController.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import UIKit

final class UsersViewController: UIViewController {

    // MARK: - Neested Types

    private enum Constant {

    }

    // MARK: - Public Properties

    var output: UsersViewOutput?

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

}

// MARK: - Public Methods

extension UsersViewController {

}

// MARK: - UsersViewInput

extension UsersViewController: UsersViewInput {

    func configure(state: State<[UserCellViewModel]>) {
        switch state {
        case .error:
            configureErrorState()
        case .data(let viewModels):
            configureDateState(viewModels)
        case .empty:
            configureEmptyState()
        case .loading:
            configureLoadingState()
            activityIndicatorView.startAnimating()
        }
    }

}

// MARK: - Private methods

private extension UsersViewController {

    private func configureAppearance() {
        configureView()
        configureSubviews()
        configureNavigation()
        configureConstraints()
        configureInitialState()
    }

    private func configureNavigation() {
        navigationItem.title = "Users"
    }

    private func configureView() {
        tableView.dataSource = dataSource
        tableView.delegate = self

        tableView.register(UserCell.self)
        tableView.backgroundView = activityIndicatorView

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
        /* do nothing */
    }

    private func configureErrorState() {
        activityIndicatorView.stopAnimating()
    }

    private func configureDateState(_ viewModels: [UserCellViewModel]) {
        activityIndicatorView.stopAnimating()

        var snapshot = Snapshot()
        let cells: [Cell] = viewModels.map { .userCell($0) }

        snapshot.appendSections([.main])
        snapshot.appendItems(cells, toSection: .main)

        dataSource.apply(snapshot)
    }

    private func configureEmptyState() {
        activityIndicatorView.stopAnimating()
    }

    private func configureLoadingState() {
        activityIndicatorView.startAnimating()
    }

}

extension UsersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()

        let section = snapshot.sectionIdentifiers[indexPath.section]
        let cell = snapshot.itemIdentifiers[indexPath.item]

        if section == .main, case .userCell(let viewModel) = cell {
            viewModel.onSelect?()
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

}

private enum Section {

    case main

}

private enum Cell: Hashable {

    case userCell(UserCellViewModel)

}

private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Cell>

private final class DataSource: UITableViewDiffableDataSource<Section, Cell> {

    static func create(tableView: UITableView) -> DataSource {
        DataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .userCell(let viewModel):
                let cell = tableView.dequeueReusableCell(withClass: UserCell.self, for: indexPath)
                cell.configure(with: viewModel)
                return cell
            }
        }
    }

}
